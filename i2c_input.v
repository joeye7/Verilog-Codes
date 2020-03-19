// Filename:  i2c_input.v
// Author:  Joey Martin Esteves
// Date:  March 19, 2020
// Description:  16 Bit Front end input block for I2C interface. Simplified to exclude acknowledge bit.
// First byte is 7 bit address followed by a write bit of "0".
// Second byte is 8 bit data byte.
// No acknowledge bit is needed in this code. Data byte immediately follows address byte.
module i2c_input (
    input   SDA,
    input   SCL,
    input   RSTN,
    output  reg[15:0]   Q,
    output  reg START,
    output  reg STOP,
    output  reg ID
);
// Declarations
reg[15:0]   INTQ;
// Initial Reset
always @ (negedge RSTN)
    if (!RSTN) begin
    Q <= 'h0;
    INTQ <= 'h0;
    START <= 0;
    STOP <= 0;
    ID <= 0;
    end
// START and STOP Operation
always @ (negedge SDA)
    if (SCL) begin
    START <= 1;
    STOP <= 0;
    ID <=0;
    end
always @ (posedge SDA)
    if (SCL) begin
    START <= 0;
    STOP <= 1;
    end
// Serial Data Input Operation
always @ (posedge SCL)
    if (START) begin
    INTQ <= {INTQ[14:0], SDA};
    end
// ID Recognition. ID Code = 101 0011 or 7'h53.
always @ (posedge STOP)
    if (INTQ[15:9] == 7'h53) begin
    ID <= 1;
    Q <= INTQ;
    end
endmodule
