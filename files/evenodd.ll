@evenstring = global [7 x i8] c"Even!\0A\00"
@oddstring = global [6 x i8] c"Odd!\0A\00"

declare void @printString(i8*)

define i1 @even(i32 %n) {
entry:
  %n.addr = alloca i32
  store i32 %n, i32* %n.addr
  %z.addr = alloca i32
  store i32 0, i32* %z.addr
  %0 = load i32* %z.addr
  %t = load i32* %n.addr
  %cmp = icmp eq i32 %0, %t
  br i1 %cmp, label %if.then, label %if.else

if.then:
  ret i1 1

if.else:
  %1 = load i32* %n.addr
  %sub = sub nsw i32 %1, 1
  %call = call i1 @odd(i32 %sub)
  ret i1 %call

if.end:
  unreachable
}

define i1 @odd(i32 %n) {
entry:
  %n.addr = alloca i32
  store i32 %n, i32* %n.addr
  %z.addr = alloca i32
  store i32 0, i32* %z.addr
  %0 = load i32* %z.addr
  %t = load i32* %n.addr
  %cmp = icmp eq i32 %0, %t
  br i1 %cmp, label %if.then, label %if.else

if.then:
  ret i1 0

if.else:
  %1 = load i32* %n.addr
  %sub = sub nsw i32 %1, 1
  %call = call i1 @even(i32 %sub)
  ret i1 %call

if.end:
  unreachable
}

define i32 @main() {
entry:
  %n = alloca i32
  store i32 20, i32* %n
  %t = load i32* %n
  %b = call i1 @even(i32 %t)
  br i1 %b, label %if.then, label %if.else

if.then:
  %strp = getelementptr [7 x i8]* @evenstring, i32 0, i32 0
  call void @printString(i8* %strp)
  br label %if.end

if.else:
  %strp1 = getelementptr [6 x i8]* @oddstring, i32 0, i32 0
  call void @printString(i8* %strp1)
  br label %if.end

if.end:
  ret i32 0

}
