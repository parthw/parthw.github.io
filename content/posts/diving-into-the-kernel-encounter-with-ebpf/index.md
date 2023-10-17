---
title: "Diving into the Kernel: Encounter with eBPF"
author: Parth Wadhwa
date: "2023-10-13"
---

Hello there! I recently became fascinated by the world of monitoring, which eventually led me to discover eBPF.
As I started digging into eBPF, I found it super cool and got hooked. It made me want to explore the inner workings of the kernel.
With this newfound enthusiasm, I'm excited to announce the launch of my own blog series where I'll share my experiences and insights about eBPF and kernel as I learn along the way.

## The Linux Kernel

To understand eBPF, you will need to understand what is kernel, what is user space and what is system call.

The Linux kernel is the software layer that acts as an intermediary between applications and the underlying hardware on which they operate. Our applications run in an unprivileged layer known as 'user space', and they lack direct access to hardware. Instead, applications communicate with the hardware through a system call interface, where they request the kernel to facilitate interactions with the hardware on their behalf. The resposibilities of kernel also include handling scheduling, concurreny of processes, memory management etc. This is better illustrated in [nutanixbibile.com](https://www.nutanixbible.com/0-a-brief-lesson-in-history.html) as -

![user_kernel](user_kernel.png)

## What is eBPF?

Extended Berkeley Packet Filter (eBPF) is a Linux kernel feature that makes it possible to run sandboxed programs inside the kernel space in a safe and controlled manner, allowing us to modify and extend the kernel without having to alter and re-compiling the kernel’s source code. `Don't judge it by name, it is not just a packet filter anymore.`

It was introduced in the Linux kernel version 3.15 in 2014. It was originally developed as an extension of the Berkeley Packet Filter (BPF) to allow more complex and dynamic filtering of network packets. Since then, eBPF has evolved to become a powerful and flexible tool for tracing, profiling, security analysis etc.

> In Brendan Gregg’s own words: "eBPF does to Linux what JavaScript does to HTML."

One of eBPF's most notable aspects is the `eBPF verifier`, a component that enhances the safety of kernel execution. Allow me to clarify what `safer` means in this context.

In the past, if you needed a specific feature in the kernel, the process involved making a request within the kernel community. Even if you embarked on the development journey, there was no guarantee that your changes would be accepted. Moreover, releasing these kernel modifications and having them integrated into the OS your organization uses is a time-consuming process which can take few months to years.

An alternative approach was to utilize kernel modules, which could be loaded or unloaded on demand. These modules offered a way to tweak the behavior of the kernel. However, writing a kernel module required utmost caution because any mistakes or crashes in the module could lead to a kernel panic, taking down the entire system.

The eBPF verifier enables the safe execution of a program. This means that if the program encounters any issues, it will not lead to a system crash or kernel panic.

Without further ado, let us set up our development environment and learn by doing, as it is more exciting.
## Development environment

I'm currently doing development using Ubuntu 22.04.3 in virtual machine with kernel version 6.2.
I've chosen to use a virtual machine as a safety measure to avoid the risk of potentially damaging my primary system.
 
To get started, the first step is to run the following commands to install the necessary packages:

```bash
sudo apt install -y linux-headers-$(uname -r) libbpfcc-dev libbpf-dev llvm clang libclang-dev gcc-multilib build-essential linux-tools-$(uname -r) linux-tools-common linux-tools-generic vim python-is-python3 elfutils dwarves git flex bison libssl-dev libelf-dev cmake libedit-dev zip libfl-dev python3-setuptools liblzma-dev libdebuginfod-dev arping netperf iperf


sudo apt-get -y install luajit luajit-5.1-dev
```
These commands will set up LLVM, Clang, and other packages on your system. We will be discussing most of them in upcoming blog posts when we use them. The important thing to note is that these commands will set up LLVM version 14 if you are using Ubuntu 22.04.3. LLVM version can vary according to the Ubuntu version in use.

We'll also be writing the code in golang so, to install the latest version of golang, run the following commands:

```bash
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go
```

In start, we will also use the most accessible approch to write eBPF programs that is via the BCC Python Framework.
Next we will be setting up, bcc framework and run an example to verify whether the setup is done correctly or not.
The official instructions are mentioned on [BCC install.md](https://github.com/iovisor/bcc/blob/master/INSTALL.md#ubuntu---source).

> Note: If you are using Ubuntu 20.04, you will need to upgrade LLVM to version 11 or above to compile iovisor BCC; or you can use the environment variable LLVM_ROOT to select the alternative LLVM version. In this series, we will be going ahead with llvm version 14.

With the above packages, to install and compile BCC framework, run the following commands:
```bash
git clone https://github.com/iovisor/bcc.git
mkdir bcc/build; cd bcc/build
cmake ..
make
sudo make install
cmake -DPYTHON_CMD=python3 .. # build python3 binding
pushd src/python/
make
sudo make install
popd
```

## Verify the setup

To verify that iovisor BCC is installed and configured correctly, run the following command:
```bash
cd /usr/share/bcc/examples
./hello_world.py
```

If you see the output as `Hello, World!`, then the setup is correct.

I remember the first time I ran this command. It was like entering a mysterious territory full of new possibilities. Seeing the "Hello, World!" output gave me the confidence to dig deeper. And I'm hooked.
## Upcoming post

In my next post, I'll walk you through the steps of creating your first "Hello, World!" eBPF program, line by line. I'll also introduce some of the more exciting eBPF constructs, such as maps, kernel probes and how to use them to write useful eBPF programs.

Thanks for reading and stay tuned!
