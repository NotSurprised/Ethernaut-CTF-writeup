# Hello Ethernaut
```javascript
> contract.info()
v Promise {<pending>}
    >__proto__: Promise
    >[[PromiseStatus]]: "resolved"
    >[[PromiseValue]]: "You will find what you need in info1()."
> contract.info1()
v Promise {<pending>}
    >__proto__: Promise
    >[[PromiseStatus]]: "resolved"
    >[[PromiseValue]]: "Try info2(), but with "hello" as a parameter."
> contract.info2("hello")
v Promise {<pending>}
    >__proto__: Promise
    >[[PromiseStatus]]: "resolved"
    >[[PromiseValue]]: "The property infoNum holds the number of the next info method to call."
> contract.infoNum()
v Promise {<pending>}
    >__proto__: Promise
    >[[PromiseStatus]]: "resolved"
    v[[PromiseValue]]: t
        >c: [42]
         e: 1
         s: 1
        >__proto__: Object
> contract.info42()
v Promise {<pending>}
    >__proto__: Promise
    >[[PromiseStatus]]: "resolved"
    >[[PromiseValue]]: "theMethodName is the name of the next method."
> contract.theMethodName()
v Promise {<pending>}
    >__proto__: Promise
    >[[PromiseStatus]]: "resolved"
    >[[PromiseValue]]: "The method name is method7123949."
> contract.method7123949()
v Promise {<pending>}
    >__proto__: Promise
    >[[PromiseStatus]]: "resolved"
    >[[PromiseValue]]: "If you know the password, submit it to authenticate()."
> contract.abi
V (11) [{…}, {…}, {…}, {…}, {…}, {…}, {…}, {…}, {…}, {…}, {…}]
    >0: {constant: true, inputs: Array(0), name: "password", outputs: Array(1), payable: false, …}
    >1: {constant: true, inputs: Array(0), name: "infoNum", outputs: Array(1), payable: false, …}
    >2: {constant: true, inputs: Array(0), name: "theMethodName", outputs: Array(1), payable: false, …}
    >3: {inputs: Array(1), payable: false, stateMutability: "nonpayable", type: "constructor"}
    >4: {constant: true, inputs: Array(0), name: "info", outputs: Array(1), payable: false, …}
    >5: {constant: true, inputs: Array(0), name: "info1", outputs: Array(1), payable: false, …}
    >6: {constant: true, inputs: Array(1), name: "info2", outputs: Array(1), payable: false, …}
    >7: {constant: true, inputs: Array(0), name: "info42", outputs: Array(1), payable: false, …}
    >8: {constant: true, inputs: Array(0), name: "method7123949", outputs: Array(1), payable: false, …}
    >9: {constant: false, inputs: Array(1), name: "authenticate", outputs: Array(0), payable: false, …}
    >10: {constant: true, inputs: Array(0), name: "getCleared", outputs: Array(1), payable: false, …}
     length: 11
    >__proto__: Array(0)
> contract.password()
v Promise {<pending>}
    >__proto__: Promise
    >[[PromiseStatus]]: "resolved"
    >[[PromiseValue]]: "ethernaut0"
> contract.authenticate("ethernaut0")
```