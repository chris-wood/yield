; ModuleID = 'C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/vhls/set/solution/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-w64-mingw32"

@set_str = internal unnamed_addr constant [4 x i8] c"set\00"
@p_str2 = private unnamed_addr constant [7 x i8] c"direct\00", align 1
@p_str1 = private unnamed_addr constant [6 x i8] c"m_axi\00", align 1
@p_str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

define i32 @set(i32* %gmem, i32 %data, i32 %key, i32 %val_r) {
  %val_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %val_r)
  %key_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %key)
  %data_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %data)
  %data1 = call i30 @_ssdm_op_PartSelect.i30.i32.i32.i32(i32 %data_read, i32 2, i32 31)
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %gmem), !map !1
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %key) nounwind, !map !7
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %val_r) nounwind, !map !13
  call void (...)* @_ssdm_op_SpecBitsMap(i32 0) nounwind, !map !17
  call void (...)* @_ssdm_op_SpecTopModule([4 x i8]* @set_str) nounwind
  call void (...)* @_ssdm_op_SpecLatency(i32 1, i32 65535, [1 x i8]* @p_str) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32* %gmem, [6 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str, [7 x i8]* @p_str2, [1 x i8]* @p_str, [1 x i8]* @p_str) nounwind
  call fastcc void @set_assign_val(i32* %gmem, i30 %data1, i32 %key_read, i32 %val_read)
  ret i32 0
}

declare i32 @llvm.part.select.i32(i32, i32, i32) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

define internal fastcc void @set_assign_val(i32* %dest, i30 %data1, i32 %tmp, i32 %src) {
  %src_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %src)
  %tmp_read = call i32 @_ssdm_op_Read.ap_auto.i32(i32 %tmp)
  %data1_read = call i30 @_ssdm_op_Read.ap_auto.i30(i30 %data1)
  %tmp_cast_cast = zext i32 %tmp_read to i33
  %sext_cast = zext i30 %data1_read to i33
  %sum = add i33 %tmp_cast_cast, %sext_cast
  %sum_cast = zext i33 %sum to i64
  %dest_addr = getelementptr i32* %dest, i64 %sum_cast
  call void (...)* @_ssdm_op_SpecInterface(i32* %dest, [6 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str, [7 x i8]* @p_str2, [1 x i8]* @p_str, [1 x i8]* @p_str)
  %dest_addr_req = call i1 @_ssdm_op_WriteReq.m_axi.i32P(i32* %dest_addr, i32 1)
  call void @_ssdm_op_Write.m_axi.i32P(i32* %dest_addr, i32 %src_read, i4 -1)
  %dest_addr_resp = call i1 @_ssdm_op_WriteResp.m_axi.i32P(i32* %dest_addr)
  ret void
}

define weak i1 @_ssdm_op_WriteResp.m_axi.i32P(i32*) {
entry:
  ret i1 true
}

define weak i1 @_ssdm_op_WriteReq.m_axi.i32P(i32*, i32) {
entry:
  ret i1 true
}

define weak void @_ssdm_op_Write.m_axi.i32P(i32*, i32, i4) {
entry:
  ret void
}

define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

define weak void @_ssdm_op_SpecLatency(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_Read.ap_auto.i32(i32) {
entry:
  ret i32 %0
}

define weak i30 @_ssdm_op_Read.ap_auto.i30(i30) {
entry:
  ret i30 %0
}

define weak i30 @_ssdm_op_PartSelect.i30.i32.i32.i32(i32, i32, i32) nounwind readnone {
entry:
  %empty = call i32 @llvm.part.select.i32(i32 %0, i32 %1, i32 %2)
  %empty_4 = trunc i32 %empty to i30
  ret i30 %empty_4
}

declare i16 @_ssdm_op_HSub(...)

declare i16 @_ssdm_op_HMul(...)

declare i16 @_ssdm_op_HDiv(...)

declare i16 @_ssdm_op_HAdd(...)

!hls.encrypted.func = !{}
!llvm.map.gv = !{}
!axi4.master.portmap = !{!0}
!axi4.slave.bundlemap = !{}

!0 = metadata !{metadata !"gmem", metadata !"data", metadata !"WRITEONLY"}
!1 = metadata !{metadata !2}
!2 = metadata !{i32 0, i32 31, metadata !3}
!3 = metadata !{metadata !4}
!4 = metadata !{metadata !"data", metadata !5, metadata !"unsigned int", i32 0, i32 31}
!5 = metadata !{metadata !6}
!6 = metadata !{i32 0, i32 0, i32 1}
!7 = metadata !{metadata !8}
!8 = metadata !{i32 0, i32 31, metadata !9}
!9 = metadata !{metadata !10}
!10 = metadata !{metadata !"key", metadata !11, metadata !"unsigned int", i32 0, i32 31}
!11 = metadata !{metadata !12}
!12 = metadata !{i32 0, i32 0, i32 0}
!13 = metadata !{metadata !14}
!14 = metadata !{i32 0, i32 31, metadata !15}
!15 = metadata !{metadata !16}
!16 = metadata !{metadata !"val", metadata !11, metadata !"unsigned int", i32 0, i32 31}
!17 = metadata !{metadata !18}
!18 = metadata !{i32 0, i32 31, metadata !19}
!19 = metadata !{metadata !20}
!20 = metadata !{metadata !"return", metadata !21, metadata !"int", i32 0, i32 31}
!21 = metadata !{metadata !22}
!22 = metadata !{i32 0, i32 1, i32 0}
