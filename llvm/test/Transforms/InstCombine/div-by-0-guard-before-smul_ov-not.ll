; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S -instcombine-unsafe-select-transform=0 | FileCheck %s

declare { i4, i1 } @llvm.smul.with.overflow.i4(i4, i4) #1

define i1 @t0_umul(i4 %size, i4 %nmemb) {
; CHECK-LABEL: @t0_umul(
; CHECK-NEXT:    [[NMEMB_FR:%.*]] = freeze i4 [[NMEMB:%.*]]
; CHECK-NEXT:    [[SMUL:%.*]] = tail call { i4, i1 } @llvm.smul.with.overflow.i4(i4 [[SIZE:%.*]], i4 [[NMEMB_FR]])
; CHECK-NEXT:    [[SMUL_OV:%.*]] = extractvalue { i4, i1 } [[SMUL]], 1
; CHECK-NEXT:    [[PHITMP:%.*]] = xor i1 [[SMUL_OV]], true
; CHECK-NEXT:    ret i1 [[PHITMP]]
;
  %cmp = icmp eq i4 %size, 0
  %smul = tail call { i4, i1 } @llvm.smul.with.overflow.i4(i4 %size, i4 %nmemb)
  %smul.ov = extractvalue { i4, i1 } %smul, 1
  %phitmp = xor i1 %smul.ov, true
  %or = select i1 %cmp, i1 true, i1 %phitmp
  ret i1 %or
}

define i1 @t1_commutative(i4 %size, i4 %nmemb) {
; CHECK-LABEL: @t1_commutative(
; CHECK-NEXT:    [[SMUL:%.*]] = tail call { i4, i1 } @llvm.smul.with.overflow.i4(i4 [[SIZE:%.*]], i4 [[NMEMB:%.*]])
; CHECK-NEXT:    [[SMUL_OV:%.*]] = extractvalue { i4, i1 } [[SMUL]], 1
; CHECK-NEXT:    [[PHITMP:%.*]] = xor i1 [[SMUL_OV]], true
; CHECK-NEXT:    ret i1 [[PHITMP]]
;
  %cmp = icmp eq i4 %size, 0
  %smul = tail call { i4, i1 } @llvm.smul.with.overflow.i4(i4 %size, i4 %nmemb)
  %smul.ov = extractvalue { i4, i1 } %smul, 1
  %phitmp = xor i1 %smul.ov, true
  %or = select i1 %phitmp, i1 true, i1 %cmp ; swapped
  ret i1 %or
}

define i1 @n2_wrong_size(i4 %size0, i4 %size1, i4 %nmemb) {
; CHECK-LABEL: @n2_wrong_size(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i4 [[SIZE1:%.*]], 0
; CHECK-NEXT:    [[SMUL:%.*]] = tail call { i4, i1 } @llvm.smul.with.overflow.i4(i4 [[SIZE0:%.*]], i4 [[NMEMB:%.*]])
; CHECK-NEXT:    [[SMUL_OV:%.*]] = extractvalue { i4, i1 } [[SMUL]], 1
; CHECK-NEXT:    [[PHITMP:%.*]] = xor i1 [[SMUL_OV]], true
; CHECK-NEXT:    [[OR:%.*]] = select i1 [[CMP]], i1 true, i1 [[PHITMP]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp = icmp eq i4 %size1, 0 ; not %size0
  %smul = tail call { i4, i1 } @llvm.smul.with.overflow.i4(i4 %size0, i4 %nmemb)
  %smul.ov = extractvalue { i4, i1 } %smul, 1
  %phitmp = xor i1 %smul.ov, true
  %or = select i1 %cmp, i1 true, i1 %phitmp
  ret i1 %or
}

define i1 @n3_wrong_pred(i4 %size, i4 %nmemb) {
; CHECK-LABEL: @n3_wrong_pred(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i4 [[SIZE:%.*]], 0
; CHECK-NEXT:    [[SMUL:%.*]] = tail call { i4, i1 } @llvm.smul.with.overflow.i4(i4 [[SIZE]], i4 [[NMEMB:%.*]])
; CHECK-NEXT:    [[SMUL_OV:%.*]] = extractvalue { i4, i1 } [[SMUL]], 1
; CHECK-NEXT:    [[PHITMP:%.*]] = xor i1 [[SMUL_OV]], true
; CHECK-NEXT:    [[OR:%.*]] = select i1 [[CMP]], i1 true, i1 [[PHITMP]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp = icmp ne i4 %size, 0 ; not 'eq'
  %smul = tail call { i4, i1 } @llvm.smul.with.overflow.i4(i4 %size, i4 %nmemb)
  %smul.ov = extractvalue { i4, i1 } %smul, 1
  %phitmp = xor i1 %smul.ov, true
  %or = select i1 %cmp, i1 true, i1 %phitmp
  ret i1 %or
}

define i1 @n4_not_and(i4 %size, i4 %nmemb) {
; CHECK-LABEL: @n4_not_and(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i4 [[SIZE:%.*]], 0
; CHECK-NEXT:    [[SMUL:%.*]] = tail call { i4, i1 } @llvm.smul.with.overflow.i4(i4 [[SIZE]], i4 [[NMEMB:%.*]])
; CHECK-NEXT:    [[SMUL_OV:%.*]] = extractvalue { i4, i1 } [[SMUL]], 1
; CHECK-NEXT:    [[PHITMP:%.*]] = xor i1 [[SMUL_OV]], true
; CHECK-NEXT:    [[OR:%.*]] = select i1 [[CMP]], i1 [[PHITMP]], i1 false
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp = icmp eq i4 %size, 0
  %smul = tail call { i4, i1 } @llvm.smul.with.overflow.i4(i4 %size, i4 %nmemb)
  %smul.ov = extractvalue { i4, i1 } %smul, 1
  %phitmp = xor i1 %smul.ov, true
  %or = select i1 %cmp, i1 %phitmp, i1 false ; not 'or'
  ret i1 %or
}

define i1 @n5_not_zero(i4 %size, i4 %nmemb) {
; CHECK-LABEL: @n5_not_zero(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i4 [[SIZE:%.*]], 1
; CHECK-NEXT:    [[SMUL:%.*]] = tail call { i4, i1 } @llvm.smul.with.overflow.i4(i4 [[SIZE]], i4 [[NMEMB:%.*]])
; CHECK-NEXT:    [[SMUL_OV:%.*]] = extractvalue { i4, i1 } [[SMUL]], 1
; CHECK-NEXT:    [[PHITMP:%.*]] = xor i1 [[SMUL_OV]], true
; CHECK-NEXT:    [[OR:%.*]] = select i1 [[CMP]], i1 true, i1 [[PHITMP]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp = icmp eq i4 %size, 1 ; should be '0'
  %smul = tail call { i4, i1 } @llvm.smul.with.overflow.i4(i4 %size, i4 %nmemb)
  %smul.ov = extractvalue { i4, i1 } %smul, 1
  %phitmp = xor i1 %smul.ov, true
  %or = select i1 %cmp, i1 true, i1 %phitmp
  ret i1 %or
}
