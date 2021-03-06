///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      09/Aug/2011  14:03:41 /
// IAR ANSI C/C++ Compiler V5.20.0.20892/W32 EVALUATION for ARM               /
// Copyright 1999-2008 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  E:\Mini-DS\DS203\SYS_V1.50\source\Memory.c              /
//    Command line =  E:\Mini-DS\DS203\SYS_V1.50\source\Memory.c -lA          /
//                    E:\Mini-DS\DS203\SYS_V1.50\IAR_V5_Prpject\List\ -o      /
//                    E:\Mini-DS\DS203\SYS_V1.50\IAR_V5_Prpject\Obj\          /
//                    --no_inline --endian=little --cpu=Cortex-M3 -e          /
//                    --fpu=None --dlib_config "C:\Program Files\IAR          /
//                    Systems\Embedded Workbench 5.0                          /
//                    Evaluation\ARM\INC\DLib_Config_Normal.h" -I             /
//                    E:\Mini-DS\DS203\SYS_V1.50\IAR_V5_Prpject\..\..\FWLib\i /
//                    nc\ -I E:\Mini-DS\DS203\SYS_V1.50\IAR_V5_Prpject\..\..\ /
//                    USBLib\inc\ -I E:\Mini-DS\DS203\SYS_V1.50\IAR_V5_Prpjec /
//                    t\..\include\ -I "C:\Program Files\IAR                  /
//                    Systems\Embedded Workbench 5.0 Evaluation\ARM\INC\"     /
//                    -Ohs                                                    /
//    List file    =  E:\Mini-DS\DS203\SYS_V1.50\IAR_V5_Prpject\List\Memory.s /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME Memory

        EXTERN Bot_State
        EXTERN Bulk_Data_Buff
        EXTERN CSW
        EXTERN Clash
        EXTERN Data_Len
        EXTERN Mass_Block_Size
        EXTERN SetEPRxStatus
        EXTERN SetEPTxCount
        EXTERN SetEPTxStatus
        EXTERN Set_CSW
        EXTERN UserToPMABufferCopy
        EXTERN __ExtFlash_PageRD
        EXTERN __ExtFlash_PageWR

        PUBLIC Block_Read_count
        PUBLIC Block_offset
        PUBLIC Counter
        PUBLIC Data_Buffer
        PUBLIC Idx
        PUBLIC Read_Memory
        PUBLIC TransferState
        PUBLIC Write_Memory
        
        CFI Names cfiNames0
        CFI StackFrame CFA R13 DATA
        CFI Resource R0:32, R1:32, R2:32, R3:32, R4:32, R5:32, R6:32, R7:32
        CFI Resource R8:32, R9:32, R10:32, R11:32, R12:32, R13:32, R14:32
        CFI EndNames cfiNames0
        
        CFI Common cfiCommon0 Using cfiNames0
        CFI CodeAlign 2
        CFI DataAlign 4
        CFI ReturnAddress R14 CODE
        CFI CFA R13+0
        CFI R0 Undefined
        CFI R1 Undefined
        CFI R2 Undefined
        CFI R3 Undefined
        CFI R4 SameValue
        CFI R5 SameValue
        CFI R6 SameValue
        CFI R7 SameValue
        CFI R8 SameValue
        CFI R9 SameValue
        CFI R10 SameValue
        CFI R11 SameValue
        CFI R12 Undefined
        CFI R14 SameValue
        CFI EndCommon cfiCommon0
        
// E:\Mini-DS\DS203\SYS_V1.50\source\Memory.c
//    1 /********************* (C) COPYRIGHT 2010 e-Design Co.,Ltd. ********************
//    2  File Name : Memory.c  
//    3  Version   : DS203_SYS Ver 1.5x                                  Author : bure
//    4 *******************************************************************************/
//    5 #include "Ext_Flash.h"
//    6 #include "USB_scsi.h"
//    7 #include "USB_regs.h"
//    8 #include "USB_conf.h"
//    9 #include "USB_bot.h"
//   10 #include "USB_mem.h"
//   11 #include "Config.h"
//   12 #include "Memory.h"
//   13 #include "BIOS.h"
//   14 #include "ASM.h"
//   15 
//   16 vu32 Block_Read_count = 0;
//   17 vu32 Block_offset;
//   18 vu32 Counter = 0;
//   19 u32  Idx;
//   20 u8 Data_Buffer[512+256]; 
//   21 u8 TransferState = TXFR_IDLE;
//   22 
//   23 extern u8 Bulk_Data_Buff[BULK_MAX_PACKET_SIZE];  /* data buffer*/
//   24 extern u16 Data_Len;
//   25 extern u8 Bot_State;
//   26 extern Bulk_Only_CBW CBW;
//   27 extern Bulk_Only_CSW CSW;
//   28 extern u32 Mass_Memory_Size;
//   29 extern u32 Mass_Block_Size;
//   30 
//   31 /*******************************************************************************
//   32 * Function Name  : Read_Memory
//   33 * Description    : Handle the Read operation from the microSD card.
//   34 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock0 Using cfiCommon0
        CFI Function Read_Memory
        THUMB
//   35 void Read_Memory(u32 Memory_Offset, u32 Transfer_Length)
//   36 {
Read_Memory:
        PUSH     {R4,R5,LR}
        CFI R14 Frame(CFA, -4)
        CFI R5 Frame(CFA, -8)
        CFI R4 Frame(CFA, -12)
        CFI CFA R13+12
        SUB      SP,SP,#+4
        CFI CFA R13+16
//   37   static u32 Offset, Length;
//   38 
//   39   if (TransferState == TXFR_IDLE )
        LDR.N    R4,??DataTable6  ;; TransferState
        LDRB     R2,[R4, #+0]
        CBNZ     R2,??Read_Memory_0
//   40   {
//   41     Offset = Memory_Offset * Mass_Block_Size;
        LDR.N    R5,??DataTable8  ;; Mass_Block_Size
        LDR      R2,[R5, #+0]
        MULS     R0,R0,R2
        STR      R0,[R4, #+788]
//   42     Length = Transfer_Length * Mass_Block_Size;
        MUL      R0,R1,R2
        STR      R0,[R4, #+792]
//   43     TransferState = TXFR_ONGOING;
        MOVS     R0,#+1
        STRB     R0,[R4, #+0]
        B.N      ??Read_Memory_1
//   44   }
//   45 
//   46   if (TransferState == TXFR_ONGOING )
??Read_Memory_0:
        CMP      R2,#+1
        BNE.N    ??Read_Memory_2
//   47   {
//   48     if (!Block_Read_count)
??Read_Memory_1:
        LDR      R0,[R4, #+4]
        CBNZ     R0,??Read_Memory_3
//   49     {
//   50       Clash = 1;
        LDR.N    R0,??DataTable9  ;; Clash
        MOVS     R1,#+1
        STRB     R1,[R0, #+0]
//   51       __ExtFlash_PageRD(Data_Buffer, Offset, Mass_Block_Size);           
        LDR.N    R5,??DataTable8  ;; Mass_Block_Size
        LDR      R2,[R5, #+0]
        UXTH     R2,R2
        LDR      R1,[R4, #+788]
        ADD      R0,R4,#+20
        BL       __ExtFlash_PageRD
//   52       UserToPMABufferCopy((u8 *)Data_Buffer, ENDP1_TXADDR, BULK_MAX_PACKET_SIZE);
        MOVS     R2,#+64
        MOVS     R1,#+152
        ADD      R0,R4,#+20
        BL       UserToPMABufferCopy
//   53       Block_Read_count = Mass_Block_Size - BULK_MAX_PACKET_SIZE;
        LDR      R0,[R5, #+0]
        SUBS     R0,R0,#+64
        STR      R0,[R4, #+4]
//   54       Block_offset = BULK_MAX_PACKET_SIZE;
        MOVS     R0,#+64
        B.N      ??Read_Memory_4
//   55     }
//   56     else
//   57     {
//   58       UserToPMABufferCopy((u8 *)Data_Buffer + Block_offset, ENDP1_TXADDR, BULK_MAX_PACKET_SIZE);
??Read_Memory_3:
        MOVS     R2,#+64
        MOVS     R1,#+152
        LDR      R0,[R4, #+8]
        ADDS     R0,R0,R4
        ADDS     R0,R0,#+20
        BL       UserToPMABufferCopy
//   59       Block_Read_count -= BULK_MAX_PACKET_SIZE;
        LDR      R0,[R4, #+4]
        SUBS     R0,R0,#+64
        STR      R0,[R4, #+4]
//   60       Block_offset += BULK_MAX_PACKET_SIZE;
        LDR      R0,[R4, #+8]
        ADDS     R0,R0,#+64
??Read_Memory_4:
        STR      R0,[R4, #+8]
//   61     }
//   62 
//   63     SetEPTxCount(ENDP1, BULK_MAX_PACKET_SIZE);
        MOVS     R1,#+64
        MOVS     R0,#+1
        BL       SetEPTxCount
//   64     SetEPTxStatus(ENDP1, EP_TX_VALID);
        MOVS     R1,#+48
        MOVS     R0,#+1
        BL       SetEPTxStatus
//   65     Offset += BULK_MAX_PACKET_SIZE;
        LDR      R0,[R4, #+788]
        ADDS     R0,R0,#+64
        STR      R0,[R4, #+788]
//   66     Length -= BULK_MAX_PACKET_SIZE;
        LDR      R0,[R4, #+792]
        SUBS     R0,R0,#+64
        STR      R0,[R4, #+792]
//   67 
//   68     CSW.dDataResidue -= BULK_MAX_PACKET_SIZE;
        LDR.N    R0,??DataTable10  ;; CSW
        LDR      R1,[R0, #+8]
        SUBS     R1,R1,#+64
        STR      R1,[R0, #+8]
//   69   }
//   70   if (Length == 0)
??Read_Memory_2:
        LDR      R0,[R4, #+792]
        CBNZ     R0,??Read_Memory_5
//   71   {
//   72     Block_Read_count = 0;
        STR      R0,[R4, #+4]
//   73     Block_offset = 0;
        STR      R0,[R4, #+8]
//   74     Offset = 0;
        STR      R0,[R4, #+788]
//   75     Bot_State = BOT_DATA_IN_LAST;
        LDR.N    R0,??DataTable11  ;; Bot_State
        MOVS     R1,#+3
        STRB     R1,[R0, #+0]
//   76     TransferState = TXFR_IDLE;
        MOVS     R0,#+0
        STRB     R0,[R4, #+0]
//   77   }
//   78 }
??Read_Memory_5:
        ADD      SP,SP,#+4
        CFI CFA R13+12
        POP      {R4,R5,PC}       ;; return
        CFI EndBlock cfiBlock0
//   79 /*******************************************************************************
//   80 * Function Name  : Write_Memory
//   81 * Description    : Handle the Write operation to the microSD card.
//   82 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock1 Using cfiCommon0
        CFI Function Write_Memory
        THUMB
//   83 void Write_Memory (u32 Memory_Offset, u32 Transfer_Length)
//   84 {
Write_Memory:
        PUSH     {R4,R5,LR}
        CFI R14 Frame(CFA, -4)
        CFI R5 Frame(CFA, -8)
        CFI R4 Frame(CFA, -12)
        CFI CFA R13+12
        SUB      SP,SP,#+4
        CFI CFA R13+16
//   85 
//   86   static u32 W_Offset, W_Length;
//   87 
//   88   u32 temp =  Counter + 64;
        LDR.N    R4,??DataTable6  ;; TransferState
        LDR      R2,[R4, #+12]
        ADDS     R2,R2,#+64
//   89 
//   90   if (TransferState == TXFR_IDLE )
        LDRB     R3,[R4, #+0]
        CBNZ     R3,??Write_Memory_0
//   91   {
//   92     W_Offset = Memory_Offset * Mass_Block_Size;
        LDR.N    R3,??DataTable8  ;; Mass_Block_Size
        LDR      R3,[R3, #+0]
        MULS     R0,R0,R3
        STR      R0,[R4, #+796]
//   93     W_Length = Transfer_Length * Mass_Block_Size;
        MUL      R0,R1,R3
        STR      R0,[R4, #+800]
//   94     TransferState = TXFR_ONGOING;
        MOVS     R0,#+1
        STRB     R0,[R4, #+0]
        B.N      ??Write_Memory_1
//   95   }
//   96 
//   97   if (TransferState == TXFR_ONGOING )
??Write_Memory_0:
        CMP      R3,#+1
        BNE.N    ??Write_Memory_2
//   98   {
//   99 
//  100     for (Idx = 0 ; Counter < temp; Counter++)
??Write_Memory_1:
        MOVS     R0,#+0
        STR      R0,[R4, #+16]
        LDR.N    R0,??Write_Memory_3  ;; Bulk_Data_Buff
        B.N      ??Write_Memory_4
//  101     {
//  102       *((u8 *)Data_Buffer + Counter) = Bulk_Data_Buff[Idx++];
??Write_Memory_5:
        LDR      R1,[R4, #+12]
        ADDS     R1,R1,R4
        LDRB     R3,[R0], #+1
        STRB     R3,[R1, #+20]
        LDR      R1,[R4, #+16]
        ADDS     R1,R1,#+1
        STR      R1,[R4, #+16]
//  103     }
        LDR      R1,[R4, #+12]
        ADDS     R1,R1,#+1
        STR      R1,[R4, #+12]
??Write_Memory_4:
        LDR      R1,[R4, #+12]
        CMP      R1,R2
        BCC.N    ??Write_Memory_5
//  104 
//  105     W_Offset += Data_Len;
        LDR.N    R5,??Write_Memory_3+0x4  ;; Data_Len
        LDRH     R0,[R5, #+0]
        LDR      R1,[R4, #+796]
        ADDS     R1,R0,R1
        STR      R1,[R4, #+796]
//  106     W_Length -= Data_Len;
        LDR      R2,[R4, #+800]
        SUBS     R0,R2,R0
        STR      R0,[R4, #+800]
//  107 
//  108     if (!(W_Length % Mass_Block_Size))
        LDR.N    R2,??DataTable8  ;; Mass_Block_Size
        LDR      R3,[R2, #+0]
        UDIV     R2,R0,R3
        MLS      R0,R2,R3,R0
        CBNZ     R0,??Write_Memory_6
//  109     {
//  110       Counter = 0;
        STR      R0,[R4, #+12]
//  111       Clash = 1;
        LDR.N    R0,??DataTable9  ;; Clash
        MOVS     R2,#+1
        STRB     R2,[R0, #+0]
//  112       __ExtFlash_PageWR(Data_Buffer, W_Offset - Mass_Block_Size);  
        SUBS     R1,R1,R3
        ADD      R0,R4,#+20
        BL       __ExtFlash_PageWR
//  113       __ExtFlash_PageWR(Data_Buffer + EXT_FLASH_PageSize, W_Offset - EXT_FLASH_PageSize);  
        LDR      R0,[R4, #+796]
        SUB      R1,R0,#+256
        ADD      R0,R4,#+276
        BL       __ExtFlash_PageWR
//  114     }
//  115 
//  116     CSW.dDataResidue -= Data_Len;
??Write_Memory_6:
        LDR.N    R0,??DataTable10  ;; CSW
        LDR      R1,[R0, #+8]
        LDRH     R2,[R5, #+0]
        SUBS     R1,R1,R2
        STR      R1,[R0, #+8]
//  117     SetEPRxStatus(ENDP2, EP_RX_VALID); /* enable the next transaction*/
        MOV      R1,#+12288
        MOVS     R0,#+2
        BL       SetEPRxStatus
//  118 
//  119   }
//  120 
//  121   if ((W_Length == 0) || (Bot_State == BOT_CSW_Send))
??Write_Memory_2:
        LDR      R0,[R4, #+800]
        CBZ      R0,??Write_Memory_7
        LDR.N    R0,??DataTable11  ;; Bot_State
        LDRB     R0,[R0, #+0]
        CMP      R0,#+4
        BNE.N    ??Write_Memory_8
//  122   {
//  123     Counter = 0;
??Write_Memory_7:
        MOVS     R0,#+0
        STR      R0,[R4, #+12]
//  124     Set_CSW (CSW_CMD_PASSED, SEND_CSW_ENABLE);
        MOVS     R1,#+1
        BL       Set_CSW
//  125     TransferState = TXFR_IDLE;
        MOVS     R0,#+0
        STRB     R0,[R4, #+0]
//  126   }
//  127 }
??Write_Memory_8:
        ADD      SP,SP,#+4
        CFI CFA R13+12
        POP      {R4,R5,PC}       ;; return
        Nop      
        DATA
??Write_Memory_3:
        DC32     Bulk_Data_Buff
        DC32     Data_Len
        CFI EndBlock cfiBlock1

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable6:
        DC32     TransferState

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8:
        DC32     Mass_Block_Size

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable9:
        DC32     Clash

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable10:
        DC32     CSW

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable11:
        DC32     Bot_State

        SECTION `.bss`:DATA:NOROOT(2)
TransferState:
        DS8 1
        DS8 3
Block_Read_count:
        DS8 4
Block_offset:
        DS8 4
Counter:
        DS8 4
Idx:
        DS8 4
Data_Buffer:
        DS8 768
        DS8 4
        DS8 4
        DS8 4
        DS8 4

        END
//  128 /******************************* END OF FILE **********************************/
//  129 
// 
// 804 bytes in section .bss
// 418 bytes in section .text
// 
// 418 bytes of CODE memory
// 804 bytes of DATA memory
//
//Errors: none
//Warnings: none
