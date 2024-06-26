$Name <FILENAME>

! Obj_Source
;Project created by:
;Mark Freytag SLAC
;mlf@slac.stanford.edu
;3/20/2023 Begin
;

#Include <func06.fps>

! Id_Pluto_Double[D45]:0=000000001010
! Can_Baud=400


! I0.0=GPR_00_SW1                       ;24V from pressure switch, set to turn off at 4.5psig, warning to CCS
! I0.1=GPR_00_SW2                       ;24V from pressure switch, set to turn off at 5psig, trip PCS
! I0.2=GPR_01_SW1                       ;24V from pressure switch, set to turn off at 4.5psig, warning to CCS 
! I0.3=GPR_01_SW2                       ;24V from pressure switch, set to turn off at 5psig, trip PCS
! I0.5=GFM_00_CH1                       ;Relay on flow meter
! I0.6=GFM_01_CH1                       ;Relay on stage 2 flow meter
! I0.7=MasterResetButton                ;Resets all latches for initialization purposes
! Q0.0=CHILLER_EMO                      ;Enable Chiller from PLC, no smoke, Chiller EMO ok, Key on, external permit from QB

! Pgm_Pluto:0
! Instruction_Set_3
! Ext_comm:0=Device 0,Packet 0, 1000
! Ext_comm:1=Device 0,Packet 1, 1000
;PCS PLC
;Controller for the Pumped coolant chiller and the cabinet it is in.
;4/12/2024 Added leak detetctor, state of EMO_In, Flow meter relay inputs
;

! I0.0,Static
! I0.1,Static
! I0.2,Static
! I0.3,Static
! I0.5,Static
! I0.6,Static
! I0.7,Static
! I0.31,A_Pulse,Non_Inv
! I0.32,B_Pulse,Non_Inv
! I0.33,A_Pulse,Non_Inv
! I0.34,C_Pulse,Non_Inv
! I0.37,B_Pulse,Non_Inv
! I0.40,B_Pulse,Non_Inv
! I0.41,B_Pulse,Non_Inv
! I0.42,B_Pulse,Non_Inv
! Q0.10,A_Pulse
! Q0.11,B_Pulse
! Q0.12,C_Pulse

! I0.30=EMO_In                          ;Signal from Chiller
! I0.31=Permit                          ;Permit from common controller
! I0.32=Key_Switch                      ;Key switch on FP
! I0.33=EMO_Readback                    ;Read state of EMO switch at chiller
! I0.34=NoSmoke                         ;High indicates No smoke, inverted input so ?
! I0.37=Leak_NC                         ;Leak detector NC
! I0.40=Leak_NO                         ;Leak detector NO
! I0.41=Leak_Fault_NC                   ;Leak detetctor Fault
! I0.42=Leak_Fault_NO                   ;Leak detetctor Fault
! Q0.10=APower                          ;Signal to Permit OptoIsolator and Reset Switch
! Q0.11=BPower                          ;Signal to Key Switch
! Q0.12=CPower                          ;Signal to Smoke Detector
! M0.0=SmokeFilter                      ;10 seconds
! M0.1=SmokeOkLatch                     ;
! M0.2=SmokeOkLatchStatus               ;
! M0.3=SmokeOkLatchNeedsReset           ;
! M0.4=ResetSmoke                       ;
! M0.5=PermitFilter                     ;10 seconds
! M0.6=PermitOkLatch                    ;
! M0.7=PermitOkLatchStatus              ;
! M0.8=PermitOkLatchNeedsReset          ;
! M0.9=ResetPermit                      ;
! M0.10=ExtEMOFilter                    ;2 second
! M0.11=ExtEMOOkLatch                   ;
! M0.12=ExtEMOLatchStatus               ;
! M0.13=ExtEMOOkLatchNeedsReset         ;
! M0.14=ResetExtEMO                     ;
! M0.15=LeakFilter                      ;
! M0.16=LeakOkLatch                     ;
! M0.17=LeakOkLatchStatus               ;
! M0.18=LeakOkLatchNeedsReset           ;
! M0.19=ResetLeak                       ;
! M0.20=LeakFaultFilter                 ;
! M0.21=LeakFaultOkLatch                ;
! M0.22=LeakFaultOkLatchStatus          ;
! M0.23=LeakFaultOkLatchNeedsReset      ;
! M0.24=Gpr00Sw1Fault                   ;High if > 4.5psig warning to CCS, resets at 4.0
! M0.25=Gpr00Sw2Filter                  ;2 second of Pressure switch, 5.0psig trip Chiller
! M0.26=Gpr01Sw1Fault                   ;High if > 4.5psig warning to CCS, resets at 4.0
! M0.27=Gpr01Sw2Filter                  ;2 second of Pressure switch, 5.0psig trip Chiller
! M0.29=Gpr00Sw2LatchOk                 ;
! M0.31=Gpr01Sw2LatchOk                 ;
! M0.33=Gpr00Sw2LatchStatus             ;
! M0.35=Gpr01Sw2LatchStatus             ;
! M0.37=Gpr00Sw2LatchNeedsReset         ;
! M0.39=Gpr01Sw2LatchNeedsReset         ;
! M0.41=Gpr00Sw2Reset                   ;
! M0.43=Gpr01Sw2Reset                   ;
! M0.45=GFM_00_Relay_State              ;
! M0.46=GFM_01_Relay_State              ;
! M0.48=ResetLeakFault                  ;
! M0.55=PcsPermEna                      ;Enable chiller
! M0.56=PCSPermEnaSet                   ;
! M0.57=PCSPermEnaReset                 ;
! M0.60=Allowed                         ;
! M0.61=External_EMO                    ;Reaback of external EMO H is ok, L is disabled
! M0.62=EMO_In_Valid                    ;EMO Chain Valid so far
! M0.64=Reset_i                         ;Reset through CCS
! M0.65=MasterReset                     ;or of reset_i and ResetButton 
! M0.100=ToGate00                       ;
! M0.101=ToGate01                       ;
! M0.102=ToGate02                       ;
! M0.103=ToGate03                       ;
! M0.104=ToGate04                       ;
! M0.105=ToGate05                       ;
! M0.106=ToGate06                       ;
! M0.107=ToGate07                       ;
! M0.108=ToGate08                       ;
! M0.109=ToGate09                       ;


S0.0_0=Logic
MasterReset=MasterResetButton+Reset_i
;` 
SmokeFilter=Upcount(P(SM_1Hz),NoSmoke,10)
;Test for Smoke
SmokeOkLatch=StartT(/SmokeFilter,ResetSmoke+MasterReset,1,SmokeOkLatchStatus)
; Active if smoke for 10 seconds, clear on cmd or reset switch.
SmokeOkLatchNeedsReset=/SmokeFilter*/SmokeOkLatch
; Latch after 10 seconds.
LeakFilter=Upcount(P(SM_1Hz),Leak_NC,2)
;Test for Leak
LeakOkLatch=StartT(/LeakFilter,ResetLeak+MasterReset,1,LeakOkLatchStatus)
; Active if Leak for 10 seconds, clear on cmd or reset switch.
LeakOkLatchNeedsReset=/LeakFilter*/LeakOkLatch
; Latch after 10 seconds.
LeakFaultFilter=Upcount(P(SM_1Hz),Leak_Fault_NC,2)
;Test for LeakFault
LeakFaultOkLatch=StartT(/LeakFaultFilter,ResetLeak+MasterReset,1,LeakFaultOkLatchStatus)
; Active if LeakFault for 10 seconds, clear on cmd or reset switch.
LeakFaultOkLatchNeedsReset=/LeakFaultFilter*/LeakFaultOkLatch
; Latch after 10 seconds.
PermitFilter=Upcount(P(SM_1Hz),Permit,2)
;Test for Permit
PermitOkLatch=StartT(/PermitFilter,ResetPermit+MasterReset,1,PermitOkLatchStatus)
; Active if Permit for 2 seconds, clear on cmd or reset switch.
PermitOkLatchNeedsReset=/PermitFilter*/PermitOkLatch
; 
ExtEMOFilter=Upcount(P(SM_1Hz),EMO_Readback,2)
;Test for EMO on chiller pushed
ExtEMOOkLatch=StartT(/ExtEMOFilter,ResetExtEMO+MasterReset,1,ExtEMOLatchStatus)
; Active if smoke for 10 seconds, clear on cmd or reset switch.
ExtEMOOkLatchNeedsReset=/ExtEMOFilter*/ExtEMOOkLatch
; Latch after 2 seconds (longer than IN1).
Gpr00Sw1Fault=/GPR_00_SW1
;Test for Pressure above 4.5psig, CCS Warning, resets at 4.0
Gpr00Sw2Filter=Upcount(P(SM_1Hz),GPR_00_SW2,2)
;Test for Pressure above 5psig, PLC Trip
Gpr00Sw2LatchOk=StartT(/Gpr00Sw2Filter,Gpr00Sw2Reset+MasterReset,1,Gpr00Sw2LatchStatus)
; Active if >5psig for 2 seconds, clear on cmd or reset switch.
Gpr00Sw2LatchNeedsReset=/Gpr00Sw2Filter*/Gpr00Sw2LatchOk
; Latch on Burst disk.
Gpr01Sw1Fault=/GPR_01_SW1
;Test for Pressure above 4.5psig, CCS Warning, resets at 4.0
Gpr01Sw2Filter=Upcount(P(SM_1Hz),GPR_01_SW2,2)
;Test for Pressure above 5psig, PLC Trip
Gpr01Sw2LatchOk=StartT(/Gpr01Sw2Filter,Gpr01Sw2Reset+MasterReset,1,Gpr01Sw2LatchStatus)
; Active if >5psig for 2 seconds, clear on cmd or reset switch.
Gpr01Sw2LatchNeedsReset=/Gpr01Sw2Filter*/Gpr01Sw2LatchOk
; Latch Fault error.
Allowed=Key_Switch*Permit*PcsPermEna*LeakOkLatch*LeakFaultOkLatch
; Key on, Ext permit on, and not blocked
CHILLER_EMO=Allowed*SmokeOkLatch*ExtEMOOkLatch*Gpr00Sw2LatchOk*Gpr01Sw2LatchOk
; Allowed and no smoke, ext EMO ok, and burst disks are ok. 
S(PcsPermEna)=PCSPermEnaSet
; Set if CMD is True
R(PcsPermEna)=PCSPermEnaReset
; Reset if CMD is True
External_EMO=EMO_Readback
;Read back external EMO state, no filtering needed? 
EMO_In_Valid=EMO_In
;Read back external EMO state, no filtering needed? 
GFM_00_Relay_State=GFM_00_CH1
;Read back external EMO state, no filtering needed? 
GFM_01_Relay_State=GFM_01_CH1
;Read back external EMO state, no filtering needed? 
APower
; Output A_Pulse on IQ10
BPower
; Output B_Pulse on IQ11
CPower
; Output C_Pulse on IQ12

S0.1_0=Communication
PCSPermEnaSet=Ext_Sig(0,0)
PCSPermEnaReset=Ext_Sig(1,0)
ResetSmoke=Ext_Sig(2,0)
ResetPermit=Ext_Sig(3,0)
Gpr00Sw2Reset=Ext_Sig(4,0)
Reset_i=Ext_Sig(5,0)
Gpr01Sw2Reset=Ext_Sig(6,0)
ResetExtEMO=Ext_Sig(7,0)
ResetLeak=Ext_Sig(8,0)
ResetLeakFault=Ext_Sig(9,0)
ToGate01=ToGateway_User_C(P(/SM_10Hz),1,SmokeFilter,SmokeOkLatch,SmokeOkLatchStatus,SmokeOkLatchNeedsReset,PermitFilter,PermitOkLatch,PermitOkLatchStatus,PermitOkLatchNeedsReset,ExtEMOFilter,ExtEMOOkLatch,ExtEMOLatchStatus,ExtEMOOkLatchNeedsReset,EMO_In_Valid,0,External_EMO,EMO_Readback,SR_appCRC)
ToGate02=ToGateway_User_C(P(/ToGate01),2,Gpr00Sw1Fault,0,LeakFilter,LeakOkLatch,LeakOkLatchStatus,LeakOkLatchNeedsReset,0,0,Gpr01Sw1Fault,0,LeakFaultFilter,LeakFaultOkLatch,LeakFaultOkLatchStatus,LeakFaultOkLatchNeedsReset,0,0,SR_ErrorCode)
ToGate03=ToGateway_User_C(P(/ToGate02),3,Gpr00Sw2Filter,Gpr00Sw2LatchOk,Gpr00Sw2LatchStatus,Gpr00Sw2LatchNeedsReset,0,0,0,0,Gpr01Sw2Filter,Gpr01Sw2LatchOk,Gpr01Sw2LatchStatus,Gpr01Sw2LatchNeedsReset,0,0,0,0,0)
ToGate04=ToGateway_User_C(P(/ToGate03),4,Permit,Key_Switch,EMO_Readback,NoSmoke,PcsPermEna,Allowed,CHILLER_EMO,MasterReset,GPR_00_SW1,GPR_00_SW2,GPR_01_SW1,GPR_01_SW2,0,GFM_00_Relay_State,GFM_01_Relay_State,0,0)
