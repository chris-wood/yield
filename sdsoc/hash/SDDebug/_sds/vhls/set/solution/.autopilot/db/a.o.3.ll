; ModuleID = 'C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/vhls/set/solution/.autopilot/db/a.o.3.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-w64-mingw32"

@set_str = internal unnamed_addr constant [4 x i8] c"set\00" ; [#uses=1 type=[4 x i8]*]
@p_str2 = private unnamed_addr constant [7 x i8] c"direct\00", align 1 ; [#uses=2 type=[7 x i8]*]
@p_str1 = private unnamed_addr constant [6 x i8] c"m_axi\00", align 1 ; [#uses=2 type=[6 x i8]*]
@p_str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1 ; [#uses=7 type=[1 x i8]*]

; [#uses=0]
define i32 @set(i32* %gmem, i32 %data, i32 %key, i32 %val) {
  %val_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %val) ; [#uses=1 type=i32]
  call void @llvm.dbg.value(metadata !{i32 %val_read}, i64 0, metadata !1), !dbg !13 ; [debug line = 42:48] [debug variable = val]
  %key_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %key) ; [#uses=1 type=i32]
  call void @llvm.dbg.value(metadata !{i32 %key_read}, i64 0, metadata !14), !dbg !15 ; [debug line = 42:34] [debug variable = key]
  call void @llvm.dbg.value(metadata !{i32 %key_read}, i64 0, metadata !16), !dbg !24 ; [debug line = 27:20@44:2] [debug variable = key]
  call void @llvm.dbg.value(metadata !{i32 %key_read}, i64 0, metadata !25), !dbg !26 ; [debug line = 27:36@44:2] [debug variable = h]
  %data_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %data) ; [#uses=1 type=i32]
  call void @llvm.dbg.value(metadata !{i32 %data_read}, i64 0, metadata !27), !dbg !28 ; [debug line = 42:19] [debug variable = data]
  %data1 = call i30 @_ssdm_op_PartSelect.i30.i32.i32.i32(i32 %data_read, i32 2, i32 31) ; [#uses=1 type=i30]
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %gmem), !map !29
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %key) nounwind, !map !35
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %val) nounwind, !map !41
  call void (...)* @_ssdm_op_SpecBitsMap(i32 0) nounwind, !map !45
  call void (...)* @_ssdm_op_SpecTopModule([4 x i8]* @set_str) nounwind
  call void @llvm.dbg.value(metadata !{i32 %data}, i64 0, metadata !27), !dbg !28 ; [debug line = 42:19] [debug variable = data]
  call void @llvm.dbg.value(metadata !{i32 %key}, i64 0, metadata !14), !dbg !15 ; [debug line = 42:34] [debug variable = key]
  call void @llvm.dbg.value(metadata !{i32 %val}, i64 0, metadata !1), !dbg !13 ; [debug line = 42:48] [debug variable = val]
  call void (...)* @_ssdm_op_SpecLatency(i32 1, i32 65535, [1 x i8]* @p_str) nounwind, !dbg !51 ; [debug line = 43:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %gmem, [6 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str, [7 x i8]* @p_str2, [1 x i8]* @p_str, [1 x i8]* @p_str) nounwind, !dbg !51 ; [debug line = 43:1]
  call void @llvm.dbg.value(metadata !{i32 %key}, i64 0, metadata !16), !dbg !24 ; [debug line = 27:20@44:2] [debug variable = key]
  call void @llvm.dbg.value(metadata !{i32 %key}, i64 0, metadata !25), !dbg !26 ; [debug line = 27:36@44:2] [debug variable = h]
  call void @llvm.dbg.value(metadata !{i32 %key}, i64 0, metadata !52), !dbg !22 ; [debug line = 44:2] [debug variable = h]
  call fastcc void @set_assign_val(i32* %gmem, i30 %data1, i32 %key_read, i32 %val_read), !dbg !53 ; [debug line = 45:2]
  ret i32 0, !dbg !54                             ; [debug line = 47:2]
}

; [#uses=1]
declare i32 @llvm.part.select.i32(i32, i32, i32) nounwind readnone

; [#uses=14]
declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

; [#uses=1]
define internal fastcc void @set_assign_val(i32* %dest, i30 %data1, i32 %tmp, i32 %src) {
  %src_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %src) ; [#uses=1 type=i32]
  call void @llvm.dbg.value(metadata !{i32 %src_read}, i64 0, metadata !55), !dbg !60 ; [debug line = 23:42] [debug variable = src]
  %tmp_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %tmp) ; [#uses=1 type=i32]
  %data1_read = call i30 @_ssdm_op_Read.ap_auto.i30(i30 %data1) ; [#uses=1 type=i30]
  %tmp_cast_cast = zext i32 %tmp_read to i33      ; [#uses=1 type=i33]
  %sext_cast = zext i30 %data1_read to i33        ; [#uses=1 type=i33]
  %sum = add i33 %tmp_cast_cast, %sext_cast       ; [#uses=1 type=i33]
  %sum_cast = zext i33 %sum to i64                ; [#uses=1 type=i64]
  %dest_addr = getelementptr i32* %dest, i64 %sum_cast ; [#uses=3 type=i32*]
  call void (...)* @_ssdm_op_SpecInterface(i32* %dest, [6 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str, [7 x i8]* @p_str2, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void @llvm.dbg.value(metadata !{i32* %dest}, i64 0, metadata !61), !dbg !62 ; [debug line = 23:27] [debug variable = dest]
  call void @llvm.dbg.value(metadata !{i32 %src}, i64 0, metadata !55), !dbg !60 ; [debug line = 23:42] [debug variable = src]
  %dest_addr_req = call i1 @_ssdm_op_WriteReq.m_axi.i32P(i32* %dest_addr, i32 1), !dbg !63 ; [#uses=0 type=i1] [debug line = 24:2]
  call void @_ssdm_op_Write.m_axi.i32P(i32* %dest_addr, i32 %src_read, i4 -1), !dbg !63 ; [debug line = 24:2]
  %dest_addr_resp = call i1 @_ssdm_op_WriteResp.m_axi.i32P(i32* %dest_addr), !dbg !63 ; [#uses=0 type=i1] [debug line = 24:2]
  ret void, !dbg !65                              ; [debug line = 25:1]
}

; [#uses=1]
define weak i1 @_ssdm_op_WriteResp.m_axi.i32P(i32*) {
entry:
  ret i1 true
}

; [#uses=1]
define weak i1 @_ssdm_op_WriteReq.m_axi.i32P(i32*, i32) {
entry:
  ret i1 true
}

; [#uses=1]
define weak void @_ssdm_op_Write.m_axi.i32P(i32*, i32, i4) {
entry:
  ret void
}

; [#uses=1]
define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

; [#uses=1]
define weak void @_ssdm_op_SpecLatency(...) nounwind {
entry:
  ret void
}

; [#uses=2]
define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

; [#uses=4]
define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

; [#uses=5]
define weak i32 @_ssdm_op_Read.ap_auto.i32(i32) {
entry:
  ret i32 %0
}

; [#uses=1]
define weak i30 @_ssdm_op_Read.ap_auto.i30(i30) {
entry:
  ret i30 %0
}

; [#uses=1]
define weak i30 @_ssdm_op_PartSelect.i30.i32.i32.i32(i32, i32, i32) nounwind readnone {
entry:
  %empty = call i32 @llvm.part.select.i32(i32 %0, i32 %1, i32 %2) ; [#uses=1 type=i32]
  %empty_4 = trunc i32 %empty to i30              ; [#uses=1 type=i30]
  ret i30 %empty_4
}

; [#uses=0]
declare i16 @_ssdm_op_HSub(...)

; [#uses=0]
declare i16 @_ssdm_op_HMul(...)

; [#uses=0]
declare i16 @_ssdm_op_HDiv(...)

; [#uses=0]
declare i16 @_ssdm_op_HAdd(...)

!hls.encrypted.func = !{}
!llvm.map.gv = !{}
!axi4.master.portmap = !{!0}
!axi4.slave.bundlemap = !{}

!0 = metadata !{metadata !"gmem", metadata !"data", metadata !"WRITEONLY"}
!1 = metadata !{i32 786689, metadata !2, metadata !"val", metadata !3, i32 50331690, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!2 = metadata !{i32 786478, i32 0, metadata !3, metadata !"set", metadata !"set", metadata !"_Z3setPjjj", metadata !3, i32 42, metadata !4, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !11, i32 42} ; [ DW_TAG_subprogram ]
!3 = metadata !{i32 786473, metadata !"C:/Users/sskalick/Xilinx/hash/hash/src/main.cpp", metadata !"c:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/vhls", null} ; [ DW_TAG_file_type ]
!4 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !5, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!5 = metadata !{metadata !6, metadata !7, metadata !10, metadata !8}
!6 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!7 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !8} ; [ DW_TAG_pointer_type ]
!8 = metadata !{i32 786454, null, metadata !"val_type", metadata !3, i32 18, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!9 = metadata !{i32 786468, null, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 786454, null, metadata !"key_type", metadata !3, i32 14, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!11 = metadata !{metadata !12}
!12 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!13 = metadata !{i32 42, i32 48, metadata !2, null}
!14 = metadata !{i32 786689, metadata !2, metadata !"key", metadata !3, i32 33554474, metadata !10, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!15 = metadata !{i32 42, i32 34, metadata !2, null}
!16 = metadata !{i32 786689, metadata !17, metadata !"key", metadata !3, i32 16777243, metadata !10, i32 0, metadata !22} ; [ DW_TAG_arg_variable ]
!17 = metadata !{i32 786478, i32 0, metadata !3, metadata !"hash", metadata !"hash", metadata !"_Z4hashjRj", metadata !3, i32 27, metadata !18, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !11, i32 27} ; [ DW_TAG_subprogram ]
!18 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !19, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!19 = metadata !{null, metadata !10, metadata !20}
!20 = metadata !{i32 786448, null, null, null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !21} ; [ DW_TAG_reference_type ]
!21 = metadata !{i32 786454, null, metadata !"hash_type", metadata !3, i32 16, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!22 = metadata !{i32 44, i32 2, metadata !23, null}
!23 = metadata !{i32 786443, metadata !2, i32 42, i32 53, metadata !3, i32 3} ; [ DW_TAG_lexical_block ]
!24 = metadata !{i32 27, i32 20, metadata !17, metadata !22}
!25 = metadata !{i32 790534, metadata !17, metadata !"h", null, i32 27, metadata !21, i32 0, metadata !22} ; [ DW_TAG_arg_variable_wo ]
!26 = metadata !{i32 27, i32 36, metadata !17, metadata !22}
!27 = metadata !{i32 786689, metadata !2, metadata !"data", metadata !3, i32 16777258, metadata !7, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!28 = metadata !{i32 42, i32 19, metadata !2, null}
!29 = metadata !{metadata !30}
!30 = metadata !{i32 0, i32 31, metadata !31}
!31 = metadata !{metadata !32}
!32 = metadata !{metadata !"data", metadata !33, metadata !"unsigned int", i32 0, i32 31}
!33 = metadata !{metadata !34}
!34 = metadata !{i32 0, i32 0, i32 1}
!35 = metadata !{metadata !36}
!36 = metadata !{i32 0, i32 31, metadata !37}
!37 = metadata !{metadata !38}
!38 = metadata !{metadata !"key", metadata !39, metadata !"unsigned int", i32 0, i32 31}
!39 = metadata !{metadata !40}
!40 = metadata !{i32 0, i32 0, i32 0}
!41 = metadata !{metadata !42}
!42 = metadata !{i32 0, i32 31, metadata !43}
!43 = metadata !{metadata !44}
!44 = metadata !{metadata !"val", metadata !39, metadata !"unsigned int", i32 0, i32 31}
!45 = metadata !{metadata !46}
!46 = metadata !{i32 0, i32 31, metadata !47}
!47 = metadata !{metadata !48}
!48 = metadata !{metadata !"return", metadata !49, metadata !"int", i32 0, i32 31}
!49 = metadata !{metadata !50}
!50 = metadata !{i32 0, i32 1, i32 0}
!51 = metadata !{i32 43, i32 1, metadata !23, null}
!52 = metadata !{i32 786688, metadata !23, metadata !"h", metadata !3, i32 43, metadata !21, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!53 = metadata !{i32 45, i32 2, metadata !23, null}
!54 = metadata !{i32 47, i32 2, metadata !23, null}
!55 = metadata !{i32 786689, metadata !56, metadata !"src", metadata !3, i32 33554455, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!56 = metadata !{i32 786478, i32 0, metadata !3, metadata !"assign_val", metadata !"assign_val", metadata !"_Z10assign_valRjj", metadata !3, i32 23, metadata !57, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !11, i32 23} ; [ DW_TAG_subprogram ]
!57 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !58, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!58 = metadata !{null, metadata !59, metadata !8}
!59 = metadata !{i32 786448, null, null, null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !8} ; [ DW_TAG_reference_type ]
!60 = metadata !{i32 23, i32 42, metadata !56, null}
!61 = metadata !{i32 786689, metadata !56, metadata !"dest", metadata !3, i32 16777239, metadata !59, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!62 = metadata !{i32 23, i32 27, metadata !56, null}
!63 = metadata !{i32 24, i32 2, metadata !64, null}
!64 = metadata !{i32 786443, metadata !56, i32 23, i32 47, metadata !3, i32 0} ; [ DW_TAG_lexical_block ]
!65 = metadata !{i32 25, i32 1, metadata !64, null}
