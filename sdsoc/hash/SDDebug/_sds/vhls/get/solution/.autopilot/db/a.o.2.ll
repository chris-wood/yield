; ModuleID = 'C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/vhls/get/solution/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-w64-mingw32"

@get.str = internal unnamed_addr constant [4 x i8] c"get\00" ; [#uses=1 type=[4 x i8]*]
@.str2 = private unnamed_addr constant [7 x i8] c"direct\00", align 1 ; [#uses=1 type=[7 x i8]*]
@.str1 = private unnamed_addr constant [6 x i8] c"m_axi\00", align 1 ; [#uses=1 type=[6 x i8]*]
@.str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1 ; [#uses=4 type=[1 x i8]*]

; [#uses=8]
declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

; [#uses=0]
define i32 @get(i32* %data, i32 %key, i32* %val) nounwind uwtable {
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %data) nounwind, !map !43
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %key) nounwind, !map !49
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %val) nounwind, !map !55
  call void (...)* @_ssdm_op_SpecBitsMap(i32 0) nounwind, !map !59
  call void (...)* @_ssdm_op_SpecTopModule([4 x i8]* @get.str) nounwind
  call void @llvm.dbg.value(metadata !{i32* %data}, i64 0, metadata !65), !dbg !66 ; [debug line = 33:19] [debug variable = data]
  call void @llvm.dbg.value(metadata !{i32 %key}, i64 0, metadata !67), !dbg !68 ; [debug line = 33:34] [debug variable = key]
  call void @llvm.dbg.value(metadata !{i32* %val}, i64 0, metadata !69), !dbg !70 ; [debug line = 33:49] [debug variable = val]
  call void (...)* @_ssdm_op_SpecLatency(i32 1, i32 65535, [1 x i8]* @.str) nounwind, !dbg !71 ; [debug line = 34:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %data, [6 x i8]* @.str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @.str, [7 x i8]* @.str2, [1 x i8]* @.str, [1 x i8]* @.str) nounwind, !dbg !71 ; [debug line = 34:1]
  call void @llvm.dbg.value(metadata !{i32 %key}, i64 0, metadata !73), !dbg !75 ; [debug line = 27:20@35:2] [debug variable = key]
  call void @llvm.dbg.value(metadata !{i32 %key}, i64 0, metadata !76), !dbg !77 ; [debug line = 27:36@35:2] [debug variable = h]
  call void @llvm.dbg.value(metadata !{i32 %key}, i64 0, metadata !78), !dbg !74 ; [debug line = 35:2] [debug variable = h]
  %tmp = zext i32 %key to i64, !dbg !79           ; [#uses=1 type=i64] [debug line = 36:2]
  %data.addr = getelementptr inbounds i32* %data, i64 %tmp, !dbg !79 ; [#uses=1 type=i32*] [debug line = 36:2]
  %src.assign = load i32* %data.addr, align 4, !dbg !79 ; [#uses=1 type=i32] [debug line = 36:2]
  call void @llvm.dbg.value(metadata !{i32 %src.assign}, i64 0, metadata !80), !dbg !81 ; [debug line = 23:42@36:2] [debug variable = src]
  call void @llvm.dbg.value(metadata !{i32 %src.assign}, i64 0, metadata !82), !dbg !83 ; [debug line = 23:27@36:2] [debug variable = dest]
  store i32 %src.assign, i32* %val, align 4, !dbg !79 ; [debug line = 36:2]
  ret i32 0, !dbg !84                             ; [debug line = 38:2]
}

; [#uses=1]
declare void @_ssdm_op_SpecTopModule(...)

; [#uses=1]
declare void @_ssdm_op_SpecLatency(...) nounwind

; [#uses=1]
declare void @_ssdm_op_SpecInterface(...) nounwind

; [#uses=4]
declare void @_ssdm_op_SpecBitsMap(...)

!llvm.dbg.cu = !{!0}
!hls.encrypted.func = !{}
!llvm.map.gv = !{}

!0 = metadata !{i32 786449, i32 0, i32 4, metadata !"C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/vhls/get/solution/.autopilot/db/main.pragma.2.cpp", metadata !"c:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/vhls", metadata !"clang version 3.1 ", i1 true, i1 false, metadata !"", i32 0, metadata !1, metadata !1, metadata !3, metadata !31} ; [ DW_TAG_compile_unit ]
!1 = metadata !{metadata !2}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{metadata !5, metadata !14, metadata !20, metadata !25, metadata !28}
!5 = metadata !{i32 786478, i32 0, metadata !6, metadata !"assign_val", metadata !"assign_val", metadata !"_Z10assign_valRjj", metadata !6, i32 23, metadata !7, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !12, i32 23} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 786473, metadata !"C:/Users/sskalick/Xilinx/hash/hash/src/main.cpp", metadata !"c:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/vhls", null} ; [ DW_TAG_file_type ]
!7 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{null, metadata !9, metadata !10}
!9 = metadata !{i32 786448, null, null, null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !10} ; [ DW_TAG_reference_type ]
!10 = metadata !{i32 786454, null, metadata !"val_type", metadata !6, i32 18, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!11 = metadata !{i32 786468, null, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!12 = metadata !{metadata !13}
!13 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!14 = metadata !{i32 786478, i32 0, metadata !6, metadata !"hash", metadata !"hash", metadata !"_Z4hashjRj", metadata !6, i32 27, metadata !15, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !12, i32 27} ; [ DW_TAG_subprogram ]
!15 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !16, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!16 = metadata !{null, metadata !17, metadata !18}
!17 = metadata !{i32 786454, null, metadata !"key_type", metadata !6, i32 14, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!18 = metadata !{i32 786448, null, null, null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !19} ; [ DW_TAG_reference_type ]
!19 = metadata !{i32 786454, null, metadata !"hash_type", metadata !6, i32 16, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!20 = metadata !{i32 786478, i32 0, metadata !6, metadata !"get", metadata !"get", metadata !"_Z3getPjjRj", metadata !6, i32 33, metadata !21, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32*, i32, i32*)* @get, null, null, metadata !12, i32 33} ; [ DW_TAG_subprogram ]
!21 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !22, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!22 = metadata !{metadata !23, metadata !24, metadata !17, metadata !9}
!23 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!24 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !10} ; [ DW_TAG_pointer_type ]
!25 = metadata !{i32 786478, i32 0, metadata !6, metadata !"set", metadata !"set", metadata !"_Z3setPjjj", metadata !6, i32 42, metadata !26, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !12, i32 42} ; [ DW_TAG_subprogram ]
!26 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !27, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!27 = metadata !{metadata !23, metadata !24, metadata !17, metadata !10}
!28 = metadata !{i32 786478, i32 0, metadata !6, metadata !"main", metadata !"main", metadata !"", metadata !6, i32 51, metadata !29, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !12, i32 51} ; [ DW_TAG_subprogram ]
!29 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !30, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!30 = metadata !{metadata !23}
!31 = metadata !{metadata !32}
!32 = metadata !{metadata !33, metadata !35, metadata !37, metadata !38, metadata !39, metadata !40, metadata !41}
!33 = metadata !{i32 786484, i32 0, null, metadata !"_sys_nerr", metadata !"_sys_nerr", metadata !"", metadata !34, i32 157, metadata !23, i32 0, i32 1, null} ; [ DW_TAG_variable ]
!34 = metadata !{i32 786473, metadata !"C:/Xilinx/SDSoC/2015.4/VIVADO~1/2015.4/win64/tools/clang/bin/../lib/clang/3.1/../../../x86_64-w64-mingw32/include\5Cstdlib.h", metadata !"c:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/vhls", null} ; [ DW_TAG_file_type ]
!35 = metadata !{i32 786484, i32 0, null, metadata !"__imp__osplatform", metadata !"__imp__osplatform", metadata !"", metadata !34, i32 248, metadata !36, i32 0, i32 1, null} ; [ DW_TAG_variable ]
!36 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_pointer_type ]
!37 = metadata !{i32 786484, i32 0, null, metadata !"__imp__osver", metadata !"__imp__osver", metadata !"", metadata !34, i32 257, metadata !36, i32 0, i32 1, null} ; [ DW_TAG_variable ]
!38 = metadata !{i32 786484, i32 0, null, metadata !"__imp__winver", metadata !"__imp__winver", metadata !"", metadata !34, i32 266, metadata !36, i32 0, i32 1, null} ; [ DW_TAG_variable ]
!39 = metadata !{i32 786484, i32 0, null, metadata !"__imp__winmajor", metadata !"__imp__winmajor", metadata !"", metadata !34, i32 275, metadata !36, i32 0, i32 1, null} ; [ DW_TAG_variable ]
!40 = metadata !{i32 786484, i32 0, null, metadata !"__imp__winminor", metadata !"__imp__winminor", metadata !"", metadata !34, i32 284, metadata !36, i32 0, i32 1, null} ; [ DW_TAG_variable ]
!41 = metadata !{i32 786484, i32 0, null, metadata !"_amblksiz", metadata !"_amblksiz", metadata !"", metadata !42, i32 53, metadata !11, i32 0, i32 1, null} ; [ DW_TAG_variable ]
!42 = metadata !{i32 786473, metadata !"C:/Xilinx/SDSoC/2015.4/VIVADO~1/2015.4/win64/tools/clang/bin/../lib/clang/3.1/../../../x86_64-w64-mingw32/include\5Cmalloc.h", metadata !"c:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/vhls", null} ; [ DW_TAG_file_type ]
!43 = metadata !{metadata !44}
!44 = metadata !{i32 0, i32 31, metadata !45}
!45 = metadata !{metadata !46}
!46 = metadata !{metadata !"data", metadata !47, metadata !"unsigned int", i32 0, i32 31}
!47 = metadata !{metadata !48}
!48 = metadata !{i32 0, i32 0, i32 1}
!49 = metadata !{metadata !50}
!50 = metadata !{i32 0, i32 31, metadata !51}
!51 = metadata !{metadata !52}
!52 = metadata !{metadata !"key", metadata !53, metadata !"unsigned int", i32 0, i32 31}
!53 = metadata !{metadata !54}
!54 = metadata !{i32 0, i32 0, i32 0}
!55 = metadata !{metadata !56}
!56 = metadata !{i32 0, i32 31, metadata !57}
!57 = metadata !{metadata !58}
!58 = metadata !{metadata !"val", metadata !47, metadata !"unsigned int", i32 0, i32 31}
!59 = metadata !{metadata !60}
!60 = metadata !{i32 0, i32 31, metadata !61}
!61 = metadata !{metadata !62}
!62 = metadata !{metadata !"return", metadata !63, metadata !"int", i32 0, i32 31}
!63 = metadata !{metadata !64}
!64 = metadata !{i32 0, i32 1, i32 0}
!65 = metadata !{i32 786689, metadata !20, metadata !"data", metadata !6, i32 16777249, metadata !24, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!66 = metadata !{i32 33, i32 19, metadata !20, null}
!67 = metadata !{i32 786689, metadata !20, metadata !"key", metadata !6, i32 33554465, metadata !17, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!68 = metadata !{i32 33, i32 34, metadata !20, null}
!69 = metadata !{i32 786689, metadata !20, metadata !"val", metadata !6, i32 50331681, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!70 = metadata !{i32 33, i32 49, metadata !20, null}
!71 = metadata !{i32 34, i32 1, metadata !72, null}
!72 = metadata !{i32 786443, metadata !20, i32 33, i32 54, metadata !6, i32 2} ; [ DW_TAG_lexical_block ]
!73 = metadata !{i32 786689, metadata !14, metadata !"key", metadata !6, i32 16777243, metadata !17, i32 0, metadata !74} ; [ DW_TAG_arg_variable ]
!74 = metadata !{i32 35, i32 2, metadata !72, null}
!75 = metadata !{i32 27, i32 20, metadata !14, metadata !74}
!76 = metadata !{i32 790534, metadata !14, metadata !"h", null, i32 27, metadata !19, i32 0, metadata !74} ; [ DW_TAG_arg_variable_wo ]
!77 = metadata !{i32 27, i32 36, metadata !14, metadata !74}
!78 = metadata !{i32 786688, metadata !72, metadata !"h", metadata !6, i32 34, metadata !19, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!79 = metadata !{i32 36, i32 2, metadata !72, null}
!80 = metadata !{i32 786689, metadata !5, metadata !"src", metadata !6, i32 33554455, metadata !10, i32 0, metadata !79} ; [ DW_TAG_arg_variable ]
!81 = metadata !{i32 23, i32 42, metadata !5, metadata !79}
!82 = metadata !{i32 790534, metadata !5, metadata !"dest", null, i32 23, metadata !10, i32 0, metadata !79} ; [ DW_TAG_arg_variable_wo ]
!83 = metadata !{i32 23, i32 27, metadata !5, metadata !79}
!84 = metadata !{i32 38, i32 2, metadata !72, null}
