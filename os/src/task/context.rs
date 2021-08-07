#[derive(Copy, Clone)]
#[repr(C)]
pub struct TaskContext {
    ra: usize, // ra寄存器,记录__switch返回后应该到哪里继续执行
    sp: usize, // 被调用者保存的寄存器s0-s11，调用者保存的寄存器可以由编译器帮我们自动保存
    s: [usize; 12],
}

impl TaskContext {
    pub fn zero_init() -> Self {
        Self {
            ra: 0,
            sp: 0,
            s: [0; 12],
        }
    }
    pub fn goto_restore(kstack_ptr: usize) -> Self {
        extern "C" { fn __restore(); }
        Self {
            ra: __restore as usize,
            sp: kstack_ptr,
            s: [0; 12],
        }
    }
}

