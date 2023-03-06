#include "Vlimiter.h"
#include <verilated_vcd_c.h>

static TOP_NAME dut;
vluint64_t sim_time = 0;
int main()
{
  Verilated::traceEverOn(true);
  VerilatedVcdC *m_trace = new VerilatedVcdC;
  dut.trace(m_trace, 5);
  m_trace->open("waveform.vcd");
    dut.gain = 1;
    dut.upper_bound = 100000000;
    dut.lower_bound = -100000000;
    int32_t sign_data = 0;
    while(!(sign_data < 0 && sign_data >= -100000000))
    {
      dut.sign_data = sign_data;
      dut.eval();
      sign_data += 100000;
      m_trace->dump(sim_time);
        sim_time++;
    }
    return 0;
} 
