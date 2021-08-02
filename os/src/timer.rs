use riscv::register::time;
use crate::sbi::set_timer;
use crate::config::CLOCK_FREQ;

const TICKS_PER_SEC: usize = 100;
const MSEC_PER_SEC: usize = 1000;

pub fn get_time() -> usize {
    time::read()
}

pub fn get_time_ms() -> usize {
    time::read() / (CLOCK_FREQ / MSEC_PER_SEC)
}

// set_next_trigger 函数对 set_timer 进行了封装，它首先读取当前 mtime 的值，
// 然后计算出 10ms 之内计数器的增量，再将 mtimecmp 设置为二者的和。
// 这样，10ms 之后一个 S 特权级时钟中断就会被触发
pub fn set_next_trigger() {
    set_timer(get_time() + CLOCK_FREQ / TICKS_PER_SEC);
}
