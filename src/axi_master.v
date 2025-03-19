
module axi_master # (parameter AW=64, DW=512)
(
    input clk, resetn,

    input awvalid,
    input wvalid,
    input bready,
    input arvalid,
    input rready,

    //==================  This is an AXI4-master interface  ===================

    // "Specify write address"              -- Master --    -- Slave --
    output     [AW-1:0]                     M_AXI_AWADDR,
    output                                  M_AXI_AWVALID,
    output     [7:0]                        M_AXI_AWLEN,
    output     [2:0]                        M_AXI_AWSIZE,
    output     [3:0]                        M_AXI_AWID,
    output     [1:0]                        M_AXI_AWBURST,
    output                                  M_AXI_AWLOCK,
    output     [3:0]                        M_AXI_AWCACHE,
    output     [3:0]                        M_AXI_AWQOS,
    output     [2:0]                        M_AXI_AWPROT,
    input                                                   M_AXI_AWREADY,

    // "Write Data"                         -- Master --    -- Slave --
    output     [DW-1:0]                     M_AXI_WDATA,
    output     [(DW/8)-1:0]                 M_AXI_WSTRB,
    output                                  M_AXI_WVALID,
    output                                  M_AXI_WLAST,
    input                                                   M_AXI_WREADY,

    // "Send Write Response"                -- Master --    -- Slave --
    input[1:0]                                              M_AXI_BRESP,
    input                                                   M_AXI_BVALID,
    output                                  M_AXI_BREADY,

    // "Specify read address"               -- Master --    -- Slave --
    output     [AW-1:0]                     M_AXI_ARADDR,
    output                                  M_AXI_ARVALID,
    output     [2:0]                        M_AXI_ARPROT,
    output                                  M_AXI_ARLOCK,
    output     [3:0]                        M_AXI_ARID,
    output     [2:0]                        M_AXI_ARSIZE,
    output     [7:0]                        M_AXI_ARLEN,
    output     [1:0]                        M_AXI_ARBURST,
    output     [3:0]                        M_AXI_ARCACHE,
    output     [3:0]                        M_AXI_ARQOS,
    input                                                   M_AXI_ARREADY,

    // "Read data back to master"           -- Master --    -- Slave --
    input[DW-1:0]                                           M_AXI_RDATA,
    input                                                   M_AXI_RVALID,
    input[1:0]                                              M_AXI_RRESP,
    input                                                   M_AXI_RLAST,
    output                                  M_AXI_RREADY
    //==========================================================================

);

// AW channel
assign M_AXI_AWADDR  = 0;
assign M_AXI_AWVALID = awvalid;
assign M_AXI_AWLEN   = 0;
assign M_AXI_AWSIZE  = $clog2(DW/8);
assign M_AXI_AWID    = 0;
assign M_AXI_AWBURST = 1;
assign M_AXI_AWLOCK  = 0;
assign M_AXI_AWCACHE = 0;
assign M_AXI_AWQOS   = 0;
assign M_AXI_AWPROT  = 0;

// W channel
assign M_AXI_WDATA  = 0;
assign M_AXI_WSTRB  = -1;
assign M_AXI_WVALID = wvalid;
assign M_AXI_WLAST  = 1;

// B channel
assign M_AXI_BREADY = bready;

// AR channel
assign M_AXI_ARADDR  = 0;
assign M_AXI_ARVALID = arvalid;
assign M_AXI_ARPROT  = 0;
assign M_AXI_ARLOCK  = 0;
assign M_AXI_ARID    = 0;
assign M_AXI_ARSIZE  = $clog2(DW/8);
assign M_AXI_ARLEN   = 0;
assign M_AXI_ARBURST = 1;
assign M_AXI_ARCACHE = 0;
assign M_AXI_ARQOS   = 0;

// R channel
assign M_AXI_RREADY = rready;


endmodule