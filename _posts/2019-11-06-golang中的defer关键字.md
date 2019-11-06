---
layout: post
title:  "golang中的defer关键字"
date:   2019-11-06 11:29:46 +0800
categories: golang
---

### defer的应用场景
golang中的defer关键字经常在方法中完成一些收尾工作，常见的有数据库的关闭连接。
### defer的执行顺序
```go
package main

import "fmt"

func main() {
	for i := 0; i < 5; i++ {
		fmt.Println(i)
		defer fmt.Println(i)
	}
}

```
上面的代码运行的结果为：
> 0
> 1
> 2
> 3
> 4
> 4
> 3
> 2
> 1
> 0

之所以会出现上面的运行结果，是因为golang的程序优先执行fmt.Println(i)，当执行遇到defer关键字的时候，golang会把关键字后需要执行的操作**暂存**起来，暂存的结构很像**堆栈**。
等整个循环全部运行结束后，暂存起来的defer操作会以**出栈**的方式运行，也就是倒序运行。
所以运行结果会先有0,1,2,3,4。这个是正常循环出来的结果。然后会有4,3,2,1,0的结果，这是defer暂存的操作以出栈方式执行的结果。

### 多个defer的执行顺序
上面是一个简单的defer执行顺序实例，咱们再看一个稍微复杂的defer执行顺序实例：
```go
package main

import "fmt"

func main() {
	oneList := []int{}
	for i := 0; i < 5; i++ {
		defer fmt.Println(oneList)
		oneList = append(oneList, i)
		defer fmt.Println(i)
	}
}

```
上面代码的运行结果为：
> 4
> [0 1 2 3]
> 3
> [0 1 2]
> 2
> [0 1]
> 1
> [0]
> 0
> []

可能有人会疑惑，为什么程序没有打印**[0,1,2,3,4]**？因为当最后一次运行时，defer关键字捕获的oneList对象还没有添加4这个元素，然后运行就结束了，所以不会运行出[0,1,2,3,4]这个结果。

### defer的赋值
我们再来看一下稍微更复杂的代码
```go
package main

import "fmt"

type SortNum struct {
	IntList []int `json:"int_list"`
}

func (sn *SortNum) ReverseNum(oneInt int) {
	sn.IntList = append(sn.IntList, oneInt)
	fmt.Println(*sn)
}

func main() {
	var sn SortNum
	for i := 0; i < 5; i++ {
		defer sn.ReverseNum(i)
	}
	fmt.Println(sn)
}
```

上面代码的运行结果是：

> {[]}
> {[4]}
> {[4 3]}
> {[4 3 2]}
> {[4 3 2 1]}
> {[4 3 2 1 0]}

出现这种运行结果也在情理之中，首先打印的**{[]}**表示循环体外的fmt.Println(sn)，此时的sn对象还没有进行任何操作，打印出来的就是一个空的对象。而第二个输出**{[4]}**则是执行defer的第一个出栈结果，就是说defer的最后一次循环捕获的参数是4，所以就优先把4加入到sn对象的IntList中，然后依次运行，根据出栈顺序，sn对象的IntList就依次加入3,2,1,0。这也很符合程序的运行结果。

### 总结
defer 函数的运行生命周期是在函数return之前，在非defer逻辑运行完之后。以出栈的方式运行。










