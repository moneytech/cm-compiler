// RUN: %clang_cc1 %s -triple spir-unknown-unknown -cl-std=c++ -O0 -emit-llvm -o - | FileCheck %s

class P {
public:
  P(const P &Rhs) = default;

  long A;
  long B;
};

void foo(__global P *GPtr) {
// CHECK: call void @llvm.memcpy{{.*}}, {{.*}}, i32 16
  P Val = GPtr[0];
}

struct __attribute__((packed)) A { int X; };
int test(__global A *GPtr) {
// CHECK: {{.*}} = load i32, {{.*}}, align 1
  return static_cast<__generic A &>(*GPtr).X;
}
