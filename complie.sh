# Utils files
# I use  | grep Error to show only if there is error or no, Every thing else will not be shown
vcom Utils/Constants.vhd | grep Error
vcom Utils/Types.vhd -2008 | grep Error
vcom Utils/Reg.vhd | grep Error
vcom Utils/Mux2.vhd | grep Error
vcom Utils/Mux4.vhd | grep Error
vcom Utils/Mux.vhd -2008 | grep Error
vcom Utils/Decoder.vhd | grep Error
vcom Utils/Ram.vhd | grep Error
vcom Utils/ShiftRegister.vhd | grep Error
vcom Utils/Tristate.vhd | grep Error
vcom Utils/Utils.vhd | grep Error
vcom Utils/FullAdder.vhd | grep Error
vcom Utils/NBitAdder.vhd | grep Error
vcom Utils/CounterUpDown.vhd | grep Error
vcom Utils/ALU.vhd | grep Error
vcom Utils/GenenralPurposeRegFile.vhd | grep Error
vcom Utils/SP.vhd   | grep Error
vcom Utils/BuffwithFlushGen.vhd | grep Error

# others files
vcom FetchStage.vhd | grep Error

vcom AddedToPC.vhd -2008 | grep Error
vcom InstructionConvert.vhd | grep Error
vcom ControlUnit.vhd -2008 | grep Error
vcom DecodeStage.vhd -2008 | grep Error

vcom OutInstrUnit.vhd | grep Error
vcom ControlHazardsUnit.vhd | grep Error
vcom ForwardUnit.vhd | grep Error
vcom FlagsUnit.vhd | grep Error
vcom CalcRamParamsUnit.vhd | grep Error
vcom MemorySelectionUnit.vhd | grep Error
vcom ExecuteStage.vhd -2008 | grep Error

vcom MemStageOutput.vhd | grep Error
vcom MemoryStage.vhd | grep Error

vcom PCControlUnit.vhd -2008 | grep Error
vcom PipelineSystem.vhd | grep Error
