//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 18-Mar-25  DWW     1  Initial creation
//====================================================================================

/*
    Monitors an AXI memory-mapped interface, and detects and reports errors
*/


module aximm_checker # (parameter AW=64, DW=512)
(
    input clk, resetn,

    output[4:0] error_map,
    output      error,

    //===============  This is an AXIMM "monitor" interface  ==================

    (* X_INTERFACE_MODE = "monitor" *)

    // "Specify write address"              -- Master --    -- Slave --
    input     [AW-1:0]                      AXI_AWADDR,
    input                                   AXI_AWVALID,
    input     [7:0]                         AXI_AWLEN,
    input     [2:0]                         AXI_AWSIZE,
    input     [3:0]                         AXI_AWID,
    input     [1:0]                         AXI_AWBURST,
    input                                   AXI_AWLOCK,
    input     [3:0]                         AXI_AWCACHE,
    input     [3:0]                         AXI_AWQOS,
    input     [2:0]                         AXI_AWPROT,
    input                                                  AXI_AWREADY,

    // "Write Data"                         -- Master --    -- Slave --
    input     [DW-1:0]                      AXI_WDATA,
    input     [(DW/8)-1:0]                  AXI_WSTRB,
    input                                   AXI_WVALID,
    input                                   AXI_WLAST,
    input                                                   AXI_WREADY,

    // "Send Write Response"                -- Master --    -- Slave --
    input [1:0]                                             AXI_BRESP,
    input                                                   AXI_BVALID,
    input                                   AXI_BREADY,

    // "Specify read address"               -- Master --    -- Slave --
    input     [AW-1:0]                      AXI_ARADDR,
    input                                   AXI_ARVALID,
    input     [2:0]                         AXI_ARPROT,
    input                                   AXI_ARLOCK,
    input     [3:0]                         AXI_ARID,
    input     [2:0]                         AXI_ARSIZE,
    input     [7:0]                         AXI_ARLEN,
    input     [1:0]                         AXI_ARBURST,
    input     [3:0]                         AXI_ARCACHE,
    input     [3:0]                         AXI_ARQOS,
    input                                                   AXI_ARREADY,

    // "Read data back to master"           -- Master --    -- Slave --
    input [DW-1:0]                                          AXI_RDATA,
    input                                                   AXI_RVALID,
    input [1:0]                                             AXI_RRESP,
    input                                                   AXI_RLAST,
    input                                   AXI_RREADY
    //==========================================================================

);

//=============================================================================
// Track the state of AWVALID
//=============================================================================
reg prior_awvalid;
always @(posedge clk) begin
    if (resetn == 0)
        prior_awvalid <= 0;
    else
        prior_awvalid <= AXI_AWVALID;
end
//=============================================================================


//=============================================================================
// Track the state of AWREADY
//=============================================================================
reg prior_awready;
always @(posedge clk) begin
    if (resetn == 0)
        prior_awready <= 0;
    else
        prior_awready <= AXI_AWREADY;
end
//=============================================================================


//=============================================================================
// Track the state of WVALID
//=============================================================================
reg prior_wvalid;
always @(posedge clk) begin
    if (resetn == 0)
        prior_wvalid <= 0;
    else
        prior_wvalid <= AXI_WVALID;
end
//=============================================================================


//=============================================================================
// Track the state of WREADY
//=============================================================================
reg prior_wready;
always @(posedge clk) begin
    if (resetn == 0)
        prior_wready <= 0;
    else
        prior_wready <= AXI_WREADY;
end
//=============================================================================



//=============================================================================
// Track the state of BVALID
//=============================================================================
reg prior_bvalid;
always @(posedge clk) begin
    if (resetn == 0)
        prior_bvalid <= 0;
    else
        prior_bvalid <= AXI_BVALID;
end
//=============================================================================


//=============================================================================
// Track the state of BREADY
//=============================================================================
reg prior_bready;
always @(posedge clk) begin
    if (resetn == 0)
        prior_bready <= 0;
    else
        prior_bready <= AXI_BREADY;
end
//=============================================================================


//=============================================================================
// Track the state of ARVALID
//=============================================================================
reg prior_arvalid;
always @(posedge clk) begin
    if (resetn == 0)
        prior_arvalid <= 0;
    else
        prior_arvalid <= AXI_ARVALID;
end
//=============================================================================


//=============================================================================
// Track the state of ARREADY
//=============================================================================
reg prior_arready;
always @(posedge clk) begin
    if (resetn == 0)
        prior_arready <= 0;
    else
        prior_arready <= AXI_ARREADY;
end
//=============================================================================


//=============================================================================
// Track the state of RVALID
//=============================================================================
reg prior_rvalid;
always @(posedge clk) begin
    if (resetn == 0)
        prior_rvalid <= 0;
    else
        prior_rvalid <= AXI_RVALID;
end
//=============================================================================


//=============================================================================
// Track the state of RREADY
//=============================================================================
reg prior_rready;
always @(posedge clk) begin
    if (resetn == 0)
        prior_rready <= 0;
    else
        prior_rready <= AXI_RREADY;
end
//=============================================================================

// Detect the falling edge of signals we care about
wire falling_awvalid = (prior_awvalid == 1) & (AXI_AWVALID == 0);
wire falling_wvalid  = (prior_wvalid  == 1) & (AXI_WVALID  == 0);
wire falling_bvalid  = (prior_bvalid  == 1) & (AXI_BVALID  == 0);
wire falling_arvalid = (prior_arvalid == 1) & (AXI_ARVALID == 0);
wire falling_rvalid  = (prior_rvalid  == 1) & (AXI_RVALID  == 0);

// If a VALID signal falls and the prior cycle didn't have the corresponding
// READY signal, it's an error
wire aw_err = falling_awvalid & (prior_awready == 0);
wire w_err  = falling_wvalid  & (prior_wready  == 0);
wire b_err  = falling_bvalid  & (prior_bready  == 0);
wire ar_err = falling_arvalid & (prior_arready == 0);
wire r_err  = falling_rvalid  & (prior_rready  == 0);

// Stuff the error bits into "error_map"
assign error_map = {r_err, ar_err, b_err, w_err, aw_err};

// This will be high on any clock-cycle when an error occurs
assign error = (error_map != 0);


endmodule