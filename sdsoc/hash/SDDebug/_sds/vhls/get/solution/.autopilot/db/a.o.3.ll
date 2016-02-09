; ModuleID = 'C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/vhls/get/solution/.autopilot/db/a.o.3.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-w64-mingw32"

@get_str = internal unnamed_addr constant [4 x i8] c"get\00" ; [#uses=1 type=[4 x i8]*]
@p_str2 = private unnamed_addr constant [7 x i8] c"direct\00", align 1 ; [#uses=1 type=[7 x i8]*]
@p_str1 = private unnamed_addr constant [6 x i8] c"m_axi\00", align 1 ; [#uses=1 type=[6 x i8]*]
@p_str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1 ; [#uses=4 type=[1 x i8]*]

; [#uses=1]
declare i32 @llvm.part.select.i32(i32, i32, i32) nounwind readnone

; [#uses=12]
declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

; [#uses=0]
define i32 @get(i32* %gmem, i32 %data, i32 %key, i32* %val) {
  %key_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %key) ; [#uses=1 type=i32]
  call void @llvm.dbg.value(metadata !{i32 %key_read}, i64 0, metadata !1), !dbg !14 ; [debug line = 33:34] [debug variable = key]
  call void @llvm.dbg.value(metadata !{i32 %key_read}, i64 0, metadata !15), !dbg !23 ; [debug line = 27:20@35:2] [debug variable = key]
  call void @llvm.dbg.value(metadata !{i32 %key_read}, i64 0, metadata !24), !dbg !25 ; [debug line = 27:36@35:2] [debug variable = h]
  %data_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %data) ; [#uses=1 type=i32]
  call void @llvm.dbg.value(metadata !{i32 %data_read}, i64 0, metadata !26), !dbg !27 ; [debug line = 33:19] [debug variable = data]
  %tmp = call i30 @_ssdm_op_PartSelect.i30.i32.i32.i32(i32 %data_read, i32 2, i32 31) ; [#uses=1 type=i30]
  %tmp_1_cast = zext i30 %tmp to i33              ; [#uses=1 type=i33]
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %gmem), !map !28
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %key) nounwind, !map !34
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %val) nounwind, !map !40
  call void (...)* @_ssdm_op_SpecBitsMap(i32 0) nounwind, !map !44
  call void (...)* @_ssdm_op_SpecTopModule([4 x i8]* @get_str) nounwind
  call void @llvm.dbg.value(metadata !{i32 %data}, i64 0, metadata !26), !dbg !27 ; [debug line = 33:19] [debug variable = data]
  call void @llvm.dbg.value(metadata !{i32 %key}, i64 0, metadata !1), !dbg !14 ; [debug line = 33:34] [debug variable = key]
  call void @llvm.dbg.value(metadata !{i32* %val}, i64 0, metadata !50), !dbg !51 ; [debug line = 33:49] [debug variable = val]
  call void (...)* @_ssdm_op_SpecLatency(i32 1, i32 65535, [1 x i8]* @p_str) nounwind, !dbg !52 ; [debug line = 34:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %gmem, [6 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str, [7 x i8]* @p_str2, [1 x i8]* @p_str, [1 x i8]* @p_str) nounwind, !dbg !52 ; [debug line = 34:1]
  call void @llvm.dbg.value(metadata !{i32 %key}, i64 0, metadata !15), !dbg !23 ; [debug line = 27:20@35:2] [debug variable = key]
  call void @llvm.dbg.value(metadata !{i32 %key}, i64 0, metadata !24), !dbg !25 ; [debug line = 27:36@35:2] [debug variable = h]
  call void @llvm.dbg.value(metadata !{i32 %key}, i64 0, metadata !53), !dbg !21 ; [debug line = 35:2] [debug variable = h]
  %tmp_cast = zext i32 %key_read to i33, !dbg !54 ; [#uses=1 type=i33] [debug line = 36:2]
  %data2_sum = add i33 %tmp_cast, %tmp_1_cast, !dbg !54 ; [#uses=1 type=i33] [debug line = 36:2]
  %data2_sum_cast = zext i33 %data2_sum to i64, !dbg !54 ; [#uses=1 type=i64] [debug line = 36:2]
  %gmem_addr = getelementptr inbounds i32* %gmem, i64 %data2_sum_cast, !dbg !54 ; [#uses=2 type=i32*] [debug line = 36:2]
  %gmem_load_req = call i1 @_ssdm_op_ReadReq.m_axi.i32P(i32* %gmem_addr, i32 1), !dbg !54 ; [#uses=0 type=i1] [debug line = 36:2]
  %gmem_addr_read = call i32 @_ssdm_op_Read.m_axi.i32P(i32* %gmem_addr), !dbg !54 ; [#uses=1 type=i32] [debug line = 36:2]
  call void @llvm.dbg.value(metadata !{i32 %gmem_addr_read}, i64 0, metadata !55), !dbg !59 ; [debug line = 23:42@36:2] [debug variable = src]
  call void @llvm.dbg.value(metadata !{i32 %gmem_addr_read}, i64 0, metadata !60), !dbg !61 ; [debug line = 23:27@36:2] [debug variable = dest]
  call void @_ssdm_op_Write.ap_auto.i32P(i32* %val, i32 %gmem_addr_read), !dbg !54 ; [debug line = 36:2]
  ret i32 0, !dbg !62                             ; [debug line = 38:2]
}

; [#uses=1]
define weak void @_ssdm_op_Write.ap_auto.i32P(i32*, i32) {
entry:
  store i32 %1, i32* %0
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

; [#uses=1]
define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

; [#uses=4]
define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

; [#uses=1]
define weak i1 @_ssdm_op_ReadReq.m_axi.i32P(i32*, i32) {
entry:
  ret i1 true
}

; [#uses=1]
define weak i32 @_ssdm_op_Read.m_axi.i32P(i32*) {
entry:
  %empty = load i32* %0                           ; [#uses=1 type=i32]
  ret i32 %empty
}

; [#uses=2]
define weak i32 @_ssdm_op_Read.ap_auto.i32(i32) {
entry:
  ret i32 %0
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

!0 = metadata !{metadata !"gmem", metadata !"data", metadata !"READONLY"}
!1 = metadata !{i32 786689, metadata !2, metadata !"key", metadata !3, i32 33554465, metadata !10, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!2 = metadata !{i32 786478, i32 0, metadata !3, metadata !"get", metadata !"get", metadata !"_Z3getPjjRj", metadata !3, i32 33, metadata !4, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !12, i32 33} ; [ DW_TAG_subprogram ]
!3 = metadata !{i32 786473, metadata !"C:/Users/sskalick/Xilinx/hash/hash/src/main.cpp", metadata !"c:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/vhls", null} ; [ DW_TAG_file_type ]
!4 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !5, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!5 = metadata !{metadata !6, metadata !7, metadata !10, metadata !11}
!6 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!7 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !8} ; [ DW_TAG_pointer_type ]
!8 = metadata !{i32 786454, null, metadata !"val_type", metadata !3, i32 18, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!9 = metadata !{i32 786468, null, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 786454, null, metadata !"key_type", metadata !3, i32 14, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!11 = metadata !{i32 786448, null, null, null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !8} ; [ DW_TAG_reference_type ]
!12 = metadata !{metadata !13}
!13 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!14 = metadata !{i32 33, i32 34, metadata !2, null}
!15 = metadata !{i32 786689, metadata !16, metadata !"key", metadata !3, i32 16777243, metadata !10, i32 0, metadata !21} ; [ DW_TAG_arg_variable ]
!16 = metadata !{i32 786478, i32 0, metadata !3, metadata !"hash", metadata !"hash", metadata !"_Z4hashjRj", metadata !3, i32 27, metadata !17, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !12, i32 27} ; [ DW_TAG_subprogram ]
!17 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !18, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!18 = metadata !{null, metadata !10, metadata !19}
!19 = metadata !{i32 786448, null, null, null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !20} ; [ DW_TAG_reference_type ]
!20 = metadata !{i32 786454, null, metadata !"hash_type", metadata !3, i32 16, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!21 = metadata !{i32 35, i32 2, metadata !22, null}
!22 = metadata !{i32 786443, metadata !2, i32 33, i32 54, metadata !3, i32 2} ; [ DW_TAG_lexical_block ]
!23 = metadata !{i32 27, i32 20, metadata !16, metadata !21}
!24 = metadata !{i32 790534, metadata !16, metadata !"h", null, i32 27, metadata !20, i32 0, metadata !21} ; [ DW_TAG_arg_variable_wo ]
!25 = metadata !{i32 27, i32 36, metadata !16, metadata !21}
!26 = metadata !{i32 786689, metadata !2, metadata !"data", metadata !3, i32 16777249, metadata !7, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!27 = metadata !{i32 33, i32 19, metadata !2, null}
!28 = metadata !{metadata !29}
!29 = metadata !{i32 0, i32 31, metadata !30}
!30 = metadata !{metadata !31}
!31 = metadata !{metadata !"data", metadata !32, metadata !"unsigned int", i32 0, i32 31}
!32 = metadata !{metadata !33}
!33 = metadata !{i32 0, i32 0, i32 1}
!34 = metadata !{metadata !35}
!35 = metadata !{i32 0, i32 31, metadata !36}
!36 = metadata !{metadata !37}
!37 = metadata !{metadata !"key", metadata !38, metadata !"unsigned int", i32 0, i32 31}
!38 = metadata !{metadata !39}
!39 = metadata !{i32 0, i32 0, i32 0}
!40 = metadata !{metadata !41}
!41 = metadata !{i32 0, i32 31, metadata !42}
!42 = metadata !{metadata !43}
!43 = metadata !{metadata !"val", metadata !32, metadata !"unsigned int", i32 0, i32 31}
!44 = metadata !{metadata !45}
!45 = metadata !{i32 0, i32 31, metadata !46}
!46 = metadata !{metadata !47}
!47 = metadata !{metadata !"return", metadata !48, metadata !"int", i32 0, i32 31}
!48 = metadata !{metadata !49}
!49 = metadata !{i32 0, i32 1, i32 0}
!50 = metadata !{i32 786689, metadata !2, metadata !"val", metadata !3, i32 50331681, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!51 = metadata !{i32 33, i32 49, metadata !2, null}
!52 = metadata !{i32 34, i32 1, metadata !22, null}
!53 = metadata !{i32 786688, metadata !22, metadata !"h", metadata !3, i32 34, metadata !20, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!54 = metadata !{i32 36, i32 2, metadata !22, null}
!55 = metadata !{i32 786689, metadata !56, metadata !"src", metadata !3, i32 33554455, metadata !8, i32 0, metadata !54} ; [ DW_TAG_arg_variable ]
!56 = metadata !{i32 786478, i32 0, metadata !3, metadata !"assign_val", metadata !"assign_val", metadata !"_Z10assign_valRjj", metadata !3, i32 23, metadata !57, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !12, i32 23} ; [ DW_TAG_subprogram ]
!57 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !58, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!58 = metadata !{null, metadata !11, metadata !8}
!59 = metadata !{i32 23, i32 42, metadata !56, metadata !54}
!60 = metadata !{i32 790534, metadata !56, metadata !"dest", null, i32 23, metadata !8, i32 0, metadata !54} ; [ DW_TAG_arg_variable_wo ]
!61 = metadata !{i32 23, i32 27, metadata !56, metadata !54}
!62 = metadata !{i32 38, i32 2, metadata !22, null}
