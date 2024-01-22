{ fetchurl, fetchgit, linkFarm, runCommand, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [
    {
      name = "_esbuild_aix_ppc64___aix_ppc64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_aix_ppc64___aix_ppc64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/aix-ppc64/-/aix-ppc64-0.19.11.tgz";
        sha512 = "FnzU0LyE3ySQk7UntJO4+qIiQgI7KoODnZg5xzXIrFJlKd2P2gwHsHY4927xj9y5PJmJSzULiUCWmv7iWnNa7g==";
      };
    }
    {
      name = "_esbuild_android_arm64___android_arm64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_android_arm64___android_arm64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/android-arm64/-/android-arm64-0.19.11.tgz";
        sha512 = "aiu7K/5JnLj//KOnOfEZ0D90obUkRzDMyqd/wNAUQ34m4YUPVhRZpnqKV9uqDGxT7cToSDnIHsGooyIczu9T+Q==";
      };
    }
    {
      name = "_esbuild_android_arm___android_arm_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_android_arm___android_arm_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/android-arm/-/android-arm-0.19.11.tgz";
        sha512 = "5OVapq0ClabvKvQ58Bws8+wkLCV+Rxg7tUVbo9xu034Nm536QTII4YzhaFriQ7rMrorfnFKUsArD2lqKbFY4vw==";
      };
    }
    {
      name = "_esbuild_android_x64___android_x64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_android_x64___android_x64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/android-x64/-/android-x64-0.19.11.tgz";
        sha512 = "eccxjlfGw43WYoY9QgB82SgGgDbibcqyDTlk3l3C0jOVHKxrjdc9CTwDUQd0vkvYg5um0OH+GpxYvp39r+IPOg==";
      };
    }
    {
      name = "_esbuild_darwin_arm64___darwin_arm64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_darwin_arm64___darwin_arm64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/darwin-arm64/-/darwin-arm64-0.19.11.tgz";
        sha512 = "ETp87DRWuSt9KdDVkqSoKoLFHYTrkyz2+65fj9nfXsaV3bMhTCjtQfw3y+um88vGRKRiF7erPrh/ZuIdLUIVxQ==";
      };
    }
    {
      name = "_esbuild_darwin_x64___darwin_x64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_darwin_x64___darwin_x64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/darwin-x64/-/darwin-x64-0.19.11.tgz";
        sha512 = "fkFUiS6IUK9WYUO/+22omwetaSNl5/A8giXvQlcinLIjVkxwTLSktbF5f/kJMftM2MJp9+fXqZ5ezS7+SALp4g==";
      };
    }
    {
      name = "_esbuild_freebsd_arm64___freebsd_arm64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_freebsd_arm64___freebsd_arm64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/freebsd-arm64/-/freebsd-arm64-0.19.11.tgz";
        sha512 = "lhoSp5K6bxKRNdXUtHoNc5HhbXVCS8V0iZmDvyWvYq9S5WSfTIHU2UGjcGt7UeS6iEYp9eeymIl5mJBn0yiuxA==";
      };
    }
    {
      name = "_esbuild_freebsd_x64___freebsd_x64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_freebsd_x64___freebsd_x64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/freebsd-x64/-/freebsd-x64-0.19.11.tgz";
        sha512 = "JkUqn44AffGXitVI6/AbQdoYAq0TEullFdqcMY/PCUZ36xJ9ZJRtQabzMA+Vi7r78+25ZIBosLTOKnUXBSi1Kw==";
      };
    }
    {
      name = "_esbuild_linux_arm64___linux_arm64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_linux_arm64___linux_arm64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/linux-arm64/-/linux-arm64-0.19.11.tgz";
        sha512 = "LneLg3ypEeveBSMuoa0kwMpCGmpu8XQUh+mL8XXwoYZ6Be2qBnVtcDI5azSvh7vioMDhoJFZzp9GWp9IWpYoUg==";
      };
    }
    {
      name = "_esbuild_linux_arm___linux_arm_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_linux_arm___linux_arm_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/linux-arm/-/linux-arm-0.19.11.tgz";
        sha512 = "3CRkr9+vCV2XJbjwgzjPtO8T0SZUmRZla+UL1jw+XqHZPkPgZiyWvbDvl9rqAN8Zl7qJF0O/9ycMtjU67HN9/Q==";
      };
    }
    {
      name = "_esbuild_linux_ia32___linux_ia32_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_linux_ia32___linux_ia32_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/linux-ia32/-/linux-ia32-0.19.11.tgz";
        sha512 = "caHy++CsD8Bgq2V5CodbJjFPEiDPq8JJmBdeyZ8GWVQMjRD0sU548nNdwPNvKjVpamYYVL40AORekgfIubwHoA==";
      };
    }
    {
      name = "_esbuild_linux_loong64___linux_loong64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_linux_loong64___linux_loong64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/linux-loong64/-/linux-loong64-0.19.11.tgz";
        sha512 = "ppZSSLVpPrwHccvC6nQVZaSHlFsvCQyjnvirnVjbKSHuE5N24Yl8F3UwYUUR1UEPaFObGD2tSvVKbvR+uT1Nrg==";
      };
    }
    {
      name = "_esbuild_linux_mips64el___linux_mips64el_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_linux_mips64el___linux_mips64el_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/linux-mips64el/-/linux-mips64el-0.19.11.tgz";
        sha512 = "B5x9j0OgjG+v1dF2DkH34lr+7Gmv0kzX6/V0afF41FkPMMqaQ77pH7CrhWeR22aEeHKaeZVtZ6yFwlxOKPVFyg==";
      };
    }
    {
      name = "_esbuild_linux_ppc64___linux_ppc64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_linux_ppc64___linux_ppc64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/linux-ppc64/-/linux-ppc64-0.19.11.tgz";
        sha512 = "MHrZYLeCG8vXblMetWyttkdVRjQlQUb/oMgBNurVEnhj4YWOr4G5lmBfZjHYQHHN0g6yDmCAQRR8MUHldvvRDA==";
      };
    }
    {
      name = "_esbuild_linux_riscv64___linux_riscv64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_linux_riscv64___linux_riscv64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/linux-riscv64/-/linux-riscv64-0.19.11.tgz";
        sha512 = "f3DY++t94uVg141dozDu4CCUkYW+09rWtaWfnb3bqe4w5NqmZd6nPVBm+qbz7WaHZCoqXqHz5p6CM6qv3qnSSQ==";
      };
    }
    {
      name = "_esbuild_linux_s390x___linux_s390x_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_linux_s390x___linux_s390x_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/linux-s390x/-/linux-s390x-0.19.11.tgz";
        sha512 = "A5xdUoyWJHMMlcSMcPGVLzYzpcY8QP1RtYzX5/bS4dvjBGVxdhuiYyFwp7z74ocV7WDc0n1harxmpq2ePOjI0Q==";
      };
    }
    {
      name = "_esbuild_linux_x64___linux_x64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_linux_x64___linux_x64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/linux-x64/-/linux-x64-0.19.11.tgz";
        sha512 = "grbyMlVCvJSfxFQUndw5mCtWs5LO1gUlwP4CDi4iJBbVpZcqLVT29FxgGuBJGSzyOxotFG4LoO5X+M1350zmPA==";
      };
    }
    {
      name = "_esbuild_netbsd_x64___netbsd_x64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_netbsd_x64___netbsd_x64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/netbsd-x64/-/netbsd-x64-0.19.11.tgz";
        sha512 = "13jvrQZJc3P230OhU8xgwUnDeuC/9egsjTkXN49b3GcS5BKvJqZn86aGM8W9pd14Kd+u7HuFBMVtrNGhh6fHEQ==";
      };
    }
    {
      name = "_esbuild_openbsd_x64___openbsd_x64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_openbsd_x64___openbsd_x64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/openbsd-x64/-/openbsd-x64-0.19.11.tgz";
        sha512 = "ysyOGZuTp6SNKPE11INDUeFVVQFrhcNDVUgSQVDzqsqX38DjhPEPATpid04LCoUr2WXhQTEZ8ct/EgJCUDpyNw==";
      };
    }
    {
      name = "_esbuild_sunos_x64___sunos_x64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_sunos_x64___sunos_x64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/sunos-x64/-/sunos-x64-0.19.11.tgz";
        sha512 = "Hf+Sad9nVwvtxy4DXCZQqLpgmRTQqyFyhT3bZ4F2XlJCjxGmRFF0Shwn9rzhOYRB61w9VMXUkxlBy56dk9JJiQ==";
      };
    }
    {
      name = "_esbuild_win32_arm64___win32_arm64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_win32_arm64___win32_arm64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/win32-arm64/-/win32-arm64-0.19.11.tgz";
        sha512 = "0P58Sbi0LctOMOQbpEOvOL44Ne0sqbS0XWHMvvrg6NE5jQ1xguCSSw9jQeUk2lfrXYsKDdOe6K+oZiwKPilYPQ==";
      };
    }
    {
      name = "_esbuild_win32_ia32___win32_ia32_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_win32_ia32___win32_ia32_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/win32-ia32/-/win32-ia32-0.19.11.tgz";
        sha512 = "6YOrWS+sDJDmshdBIQU+Uoyh7pQKrdykdefC1avn76ss5c+RN6gut3LZA4E2cH5xUEp5/cA0+YxRaVtRAb0xBg==";
      };
    }
    {
      name = "_esbuild_win32_x64___win32_x64_0.19.11.tgz";
      path = fetchurl {
        name = "_esbuild_win32_x64___win32_x64_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/@esbuild/win32-x64/-/win32-x64-0.19.11.tgz";
        sha512 = "vfkhltrjCAb603XaFhqhAF4LGDi2M4OrCRrFusyQ+iTLQ/o60QQXxc9cZC/FFpihBI9N1Grn6SMKVJ4KP7Fuiw==";
      };
    }
    {
      name = "_hebcal_core___core_5.1.0.tgz";
      path = fetchurl {
        name = "_hebcal_core___core_5.1.0.tgz";
        url  = "https://registry.yarnpkg.com/@hebcal/core/-/core-5.1.0.tgz";
        sha512 = "/3YNXkNtXB0+3GsbdPzzmM77Xi61tY//ePSVrguS6IOnyFnH/s6ozfFQl4VQgaZimqQ9zj5zo2D1v5vf90ajAw==";
      };
    }
    {
      name = "_hebcal_learning___learning_5.0.2.tgz";
      path = fetchurl {
        name = "_hebcal_learning___learning_5.0.2.tgz";
        url  = "https://registry.yarnpkg.com/@hebcal/learning/-/learning-5.0.2.tgz";
        sha512 = "2AsvHjEX4V7BdZhG48qs7U399WFbfJvVqCYE5fWhO+jELU0kJVZStcGHZXZEd0Zik3P7YmAIV/4BW1QqG9QEAg==";
      };
    }
    {
      name = "_rollup_rollup_android_arm_eabi___rollup_android_arm_eabi_4.9.6.tgz";
      path = fetchurl {
        name = "_rollup_rollup_android_arm_eabi___rollup_android_arm_eabi_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/@rollup/rollup-android-arm-eabi/-/rollup-android-arm-eabi-4.9.6.tgz";
        sha512 = "MVNXSSYN6QXOulbHpLMKYi60ppyO13W9my1qogeiAqtjb2yR4LSmfU2+POvDkLzhjYLXz9Rf9+9a3zFHW1Lecg==";
      };
    }
    {
      name = "_rollup_rollup_android_arm64___rollup_android_arm64_4.9.6.tgz";
      path = fetchurl {
        name = "_rollup_rollup_android_arm64___rollup_android_arm64_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/@rollup/rollup-android-arm64/-/rollup-android-arm64-4.9.6.tgz";
        sha512 = "T14aNLpqJ5wzKNf5jEDpv5zgyIqcpn1MlwCrUXLrwoADr2RkWA0vOWP4XxbO9aiO3dvMCQICZdKeDrFl7UMClw==";
      };
    }
    {
      name = "_rollup_rollup_darwin_arm64___rollup_darwin_arm64_4.9.6.tgz";
      path = fetchurl {
        name = "_rollup_rollup_darwin_arm64___rollup_darwin_arm64_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/@rollup/rollup-darwin-arm64/-/rollup-darwin-arm64-4.9.6.tgz";
        sha512 = "CqNNAyhRkTbo8VVZ5R85X73H3R5NX9ONnKbXuHisGWC0qRbTTxnF1U4V9NafzJbgGM0sHZpdO83pLPzq8uOZFw==";
      };
    }
    {
      name = "_rollup_rollup_darwin_x64___rollup_darwin_x64_4.9.6.tgz";
      path = fetchurl {
        name = "_rollup_rollup_darwin_x64___rollup_darwin_x64_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/@rollup/rollup-darwin-x64/-/rollup-darwin-x64-4.9.6.tgz";
        sha512 = "zRDtdJuRvA1dc9Mp6BWYqAsU5oeLixdfUvkTHuiYOHwqYuQ4YgSmi6+/lPvSsqc/I0Omw3DdICx4Tfacdzmhog==";
      };
    }
    {
      name = "_rollup_rollup_linux_arm_gnueabihf___rollup_linux_arm_gnueabihf_4.9.6.tgz";
      path = fetchurl {
        name = "_rollup_rollup_linux_arm_gnueabihf___rollup_linux_arm_gnueabihf_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/@rollup/rollup-linux-arm-gnueabihf/-/rollup-linux-arm-gnueabihf-4.9.6.tgz";
        sha512 = "oNk8YXDDnNyG4qlNb6is1ojTOGL/tRhbbKeE/YuccItzerEZT68Z9gHrY3ROh7axDc974+zYAPxK5SH0j/G+QQ==";
      };
    }
    {
      name = "_rollup_rollup_linux_arm64_gnu___rollup_linux_arm64_gnu_4.9.6.tgz";
      path = fetchurl {
        name = "_rollup_rollup_linux_arm64_gnu___rollup_linux_arm64_gnu_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/@rollup/rollup-linux-arm64-gnu/-/rollup-linux-arm64-gnu-4.9.6.tgz";
        sha512 = "Z3O60yxPtuCYobrtzjo0wlmvDdx2qZfeAWTyfOjEDqd08kthDKexLpV97KfAeUXPosENKd8uyJMRDfFMxcYkDQ==";
      };
    }
    {
      name = "_rollup_rollup_linux_arm64_musl___rollup_linux_arm64_musl_4.9.6.tgz";
      path = fetchurl {
        name = "_rollup_rollup_linux_arm64_musl___rollup_linux_arm64_musl_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/@rollup/rollup-linux-arm64-musl/-/rollup-linux-arm64-musl-4.9.6.tgz";
        sha512 = "gpiG0qQJNdYEVad+1iAsGAbgAnZ8j07FapmnIAQgODKcOTjLEWM9sRb+MbQyVsYCnA0Im6M6QIq6ax7liws6eQ==";
      };
    }
    {
      name = "_rollup_rollup_linux_riscv64_gnu___rollup_linux_riscv64_gnu_4.9.6.tgz";
      path = fetchurl {
        name = "_rollup_rollup_linux_riscv64_gnu___rollup_linux_riscv64_gnu_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/@rollup/rollup-linux-riscv64-gnu/-/rollup-linux-riscv64-gnu-4.9.6.tgz";
        sha512 = "+uCOcvVmFUYvVDr27aiyun9WgZk0tXe7ThuzoUTAukZJOwS5MrGbmSlNOhx1j80GdpqbOty05XqSl5w4dQvcOA==";
      };
    }
    {
      name = "_rollup_rollup_linux_x64_gnu___rollup_linux_x64_gnu_4.9.6.tgz";
      path = fetchurl {
        name = "_rollup_rollup_linux_x64_gnu___rollup_linux_x64_gnu_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/@rollup/rollup-linux-x64-gnu/-/rollup-linux-x64-gnu-4.9.6.tgz";
        sha512 = "HUNqM32dGzfBKuaDUBqFB7tP6VMN74eLZ33Q9Y1TBqRDn+qDonkAUyKWwF9BR9unV7QUzffLnz9GrnKvMqC/fw==";
      };
    }
    {
      name = "_rollup_rollup_linux_x64_musl___rollup_linux_x64_musl_4.9.6.tgz";
      path = fetchurl {
        name = "_rollup_rollup_linux_x64_musl___rollup_linux_x64_musl_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/@rollup/rollup-linux-x64-musl/-/rollup-linux-x64-musl-4.9.6.tgz";
        sha512 = "ch7M+9Tr5R4FK40FHQk8VnML0Szi2KRujUgHXd/HjuH9ifH72GUmw6lStZBo3c3GB82vHa0ZoUfjfcM7JiiMrQ==";
      };
    }
    {
      name = "_rollup_rollup_win32_arm64_msvc___rollup_win32_arm64_msvc_4.9.6.tgz";
      path = fetchurl {
        name = "_rollup_rollup_win32_arm64_msvc___rollup_win32_arm64_msvc_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/@rollup/rollup-win32-arm64-msvc/-/rollup-win32-arm64-msvc-4.9.6.tgz";
        sha512 = "VD6qnR99dhmTQ1mJhIzXsRcTBvTjbfbGGwKAHcu+52cVl15AC/kplkhxzW/uT0Xl62Y/meBKDZvoJSJN+vTeGA==";
      };
    }
    {
      name = "_rollup_rollup_win32_ia32_msvc___rollup_win32_ia32_msvc_4.9.6.tgz";
      path = fetchurl {
        name = "_rollup_rollup_win32_ia32_msvc___rollup_win32_ia32_msvc_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/@rollup/rollup-win32-ia32-msvc/-/rollup-win32-ia32-msvc-4.9.6.tgz";
        sha512 = "J9AFDq/xiRI58eR2NIDfyVmTYGyIZmRcvcAoJ48oDld/NTR8wyiPUu2X/v1navJ+N/FGg68LEbX3Ejd6l8B7MQ==";
      };
    }
    {
      name = "_rollup_rollup_win32_x64_msvc___rollup_win32_x64_msvc_4.9.6.tgz";
      path = fetchurl {
        name = "_rollup_rollup_win32_x64_msvc___rollup_win32_x64_msvc_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/@rollup/rollup-win32-x64-msvc/-/rollup-win32-x64-msvc-4.9.6.tgz";
        sha512 = "jqzNLhNDvIZOrt69Ce4UjGRpXJBzhUBzawMwnaDAwyHriki3XollsewxWzOzz+4yOFDkuJHtTsZFwMxhYJWmLQ==";
      };
    }
    {
      name = "_types_estree___estree_1.0.5.tgz";
      path = fetchurl {
        name = "_types_estree___estree_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/@types/estree/-/estree-1.0.5.tgz";
        sha512 = "/kYRxGDLWzHOB7q+wtSUQlFrtcdUccpfy+X+9iMBpHK8QLLhx2wIPYuS5DYtR9Wa/YlZAbIovy7qVdB1Aq6Lyw==";
      };
    }
    {
      name = "acorn_walk___acorn_walk_8.3.2.tgz";
      path = fetchurl {
        name = "acorn_walk___acorn_walk_8.3.2.tgz";
        url  = "https://registry.yarnpkg.com/acorn-walk/-/acorn-walk-8.3.2.tgz";
        sha512 = "cjkyv4OtNCIeqhHrfS81QWXoCBPExR/J62oyEqepVw8WaQeSqpW2uhuLPh1m9eWhDuOo/jUXVTlifvesOWp/4A==";
      };
    }
    {
      name = "acorn___acorn_8.11.3.tgz";
      path = fetchurl {
        name = "acorn___acorn_8.11.3.tgz";
        url  = "https://registry.yarnpkg.com/acorn/-/acorn-8.11.3.tgz";
        sha512 = "Y9rRfJG5jcKOE0CLisYbojUjIrIEE7AGMzA/Sm4BslANhbS+cDMpgBdcPT91oJ7OuJ9hYJBx59RjbhxVnrF8Xg==";
      };
    }
    {
      name = "balanced_match___balanced_match_1.0.2.tgz";
      path = fetchurl {
        name = "balanced_match___balanced_match_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/balanced-match/-/balanced-match-1.0.2.tgz";
        sha512 = "3oSeUO0TMV67hN1AmbXsK4yaqU7tjiHlbxRDZOpH0KW9+CeX4bRAaX0Anxt0tx2MrpRpWwQaPwIlISEJhYU5Pw==";
      };
    }
    {
      name = "brace_expansion___brace_expansion_1.1.11.tgz";
      path = fetchurl {
        name = "brace_expansion___brace_expansion_1.1.11.tgz";
        url  = "https://registry.yarnpkg.com/brace-expansion/-/brace-expansion-1.1.11.tgz";
        sha512 = "iCuPHDFgrHX7H2vEI/5xpz07zSHB00TpugqhmYtVmMO6518mCuRMoOYFldEBl0g187ufozdaHgWKcYFb61qGiA==";
      };
    }
    {
      name = "concat_map___concat_map_0.0.1.tgz";
      path = fetchurl {
        name = "concat_map___concat_map_0.0.1.tgz";
        url  = "https://registry.yarnpkg.com/concat-map/-/concat-map-0.0.1.tgz";
        sha512 = "/Srv4dswyQNBfohGpz9o6Yb3Gz3SrUDqBH5rTuhGR7ahtlbYKnVxw2bCFMRljaA7EXHaXZ8wsHdodFvbkhKmqg==";
      };
    }
    {
      name = "cross_spawn___cross_spawn_6.0.5.tgz";
      path = fetchurl {
        name = "cross_spawn___cross_spawn_6.0.5.tgz";
        url  = "https://registry.yarnpkg.com/cross-spawn/-/cross-spawn-6.0.5.tgz";
        sha512 = "eTVLrBSt7fjbDygz805pMnstIs2VTBNkRm0qxZd+M7A5XDdxVRWO5MxGBXZhjY4cqLYLdtrGqRf8mBPmzwSpWQ==";
      };
    }
    {
      name = "elm_esm___elm_esm_1.1.4.tgz";
      path = fetchurl {
        name = "elm_esm___elm_esm_1.1.4.tgz";
        url  = "https://registry.yarnpkg.com/elm-esm/-/elm-esm-1.1.4.tgz";
        sha512 = "dGWDtgsdDrhn3GFl/uT6Yt5DIBgnvOmakLNl6brkoYqb7i8mQ/beHoR+emx3ux4M4sq3GpRfRvzMoiRHVcaWKw==";
      };
    }
    {
      name = "esbuild___esbuild_0.19.11.tgz";
      path = fetchurl {
        name = "esbuild___esbuild_0.19.11.tgz";
        url  = "https://registry.yarnpkg.com/esbuild/-/esbuild-0.19.11.tgz";
        sha512 = "HJ96Hev2hX/6i5cDVwcqiJBBtuo9+FeIJOtZ9W1kA5M6AMJRHUZlpYZ1/SbEwtO0ioNAW8rUooVpC/WehY2SfA==";
      };
    }
    {
      name = "find_elm_dependencies___find_elm_dependencies_2.0.4.tgz";
      path = fetchurl {
        name = "find_elm_dependencies___find_elm_dependencies_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/find-elm-dependencies/-/find-elm-dependencies-2.0.4.tgz";
        sha512 = "x/4w4fVmlD2X4PD9oQ+yh9EyaQef6OtEULdMGBTuWx0Nkppvo2Z/bAiQioW2n+GdRYKypME2b9OmYTw5tw5qDg==";
      };
    }
    {
      name = "find_up___find_up_5.0.0.tgz";
      path = fetchurl {
        name = "find_up___find_up_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/find-up/-/find-up-5.0.0.tgz";
        sha512 = "78/PXT1wlLLDgTzDs7sjq9hzz0vXD+zn+7wypEe4fXQxCmdmqfGsEPQxmiCSQI3ajFV91bVSsvNtrJRiW6nGng==";
      };
    }
    {
      name = "firstline___firstline_1.3.1.tgz";
      path = fetchurl {
        name = "firstline___firstline_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/firstline/-/firstline-1.3.1.tgz";
        sha512 = "ycwgqtoxujz1dm0kjkBFOPQMESxB9uKc/PlD951dQDIG+tBXRpYZC2UmJb0gDxopQ1ZX6oyRQN3goRczYu7Deg==";
      };
    }
    {
      name = "fs.realpath___fs.realpath_1.0.0.tgz";
      path = fetchurl {
        name = "fs.realpath___fs.realpath_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/fs.realpath/-/fs.realpath-1.0.0.tgz";
        sha512 = "OO0pH2lK6a0hZnAdau5ItzHPI6pUlvI7jMVnxUQRtw4owF2wk8lOSabtGDCTP4Ggrg2MbGnWO9X8K1t4+fGMDw==";
      };
    }
    {
      name = "fsevents___fsevents_2.3.3.tgz";
      path = fetchurl {
        name = "fsevents___fsevents_2.3.3.tgz";
        url  = "https://registry.yarnpkg.com/fsevents/-/fsevents-2.3.3.tgz";
        sha512 = "5xoDfX+fL7faATnagmWPpbFtwh/R77WmMMqqHGS65C3vvB0YHrgF+B1YmZ3441tMj5n63k0212XNoJwzlhffQw==";
      };
    }
    {
      name = "glob___glob_7.2.3.tgz";
      path = fetchurl {
        name = "glob___glob_7.2.3.tgz";
        url  = "https://registry.yarnpkg.com/glob/-/glob-7.2.3.tgz";
        sha512 = "nFR0zLpU2YCaRxwoCJvL6UvCH2JFyFVIvwTLsIf21AuHlMskA1hhTdk+LlYJtOlYt9v6dvszD2BGRqBL+iQK9Q==";
      };
    }
    {
      name = "inflight___inflight_1.0.6.tgz";
      path = fetchurl {
        name = "inflight___inflight_1.0.6.tgz";
        url  = "https://registry.yarnpkg.com/inflight/-/inflight-1.0.6.tgz";
        sha512 = "k92I/b08q4wvFscXCLvqfsHCrjrF7yiXsQuIVvVE7N82W3+aqpzuUdBbfhWcy/FZR3/4IgflMgKLOsvPDrGCJA==";
      };
    }
    {
      name = "inherits___inherits_2.0.4.tgz";
      path = fetchurl {
        name = "inherits___inherits_2.0.4.tgz";
        url  = "https://registry.yarnpkg.com/inherits/-/inherits-2.0.4.tgz";
        sha512 = "k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==";
      };
    }
    {
      name = "isexe___isexe_2.0.0.tgz";
      path = fetchurl {
        name = "isexe___isexe_2.0.0.tgz";
        url  = "https://registry.yarnpkg.com/isexe/-/isexe-2.0.0.tgz";
        sha512 = "RHxMLp9lnKHGHRng9QFhRCMbYAcVpn69smSGcq3f36xjgVVWThj4qqLbTLlq7Ssj8B+fIQ1EuCEGI2lKsyQeIw==";
      };
    }
    {
      name = "locate_path___locate_path_6.0.0.tgz";
      path = fetchurl {
        name = "locate_path___locate_path_6.0.0.tgz";
        url  = "https://registry.yarnpkg.com/locate-path/-/locate-path-6.0.0.tgz";
        sha512 = "iPZK6eYjbxRu3uB4/WZ3EsEIMJFMqAoopl3R+zuq0UjcAm/MO6KCweDgPfP3elTztoKP3KtnVHxTn2NHBSDVUw==";
      };
    }
    {
      name = "lodash___lodash_4.17.21.tgz";
      path = fetchurl {
        name = "lodash___lodash_4.17.21.tgz";
        url  = "https://registry.yarnpkg.com/lodash/-/lodash-4.17.21.tgz";
        sha512 = "v2kDEe57lecTulaDIuNTPy3Ry4gLGJ6Z1O3vE1krgXZNrsQ+LFTGHVxVjcXPs17LhbZVGedAJv8XZ1tvj5FvSg==";
      };
    }
    {
      name = "minimatch___minimatch_3.1.2.tgz";
      path = fetchurl {
        name = "minimatch___minimatch_3.1.2.tgz";
        url  = "https://registry.yarnpkg.com/minimatch/-/minimatch-3.1.2.tgz";
        sha512 = "J7p63hRiAjw1NDEww1W7i37+ByIrOWO5XQQAzZ3VOcL0PNybwpfmV/N05zFAzwQ9USyEcX6t3UO+K5aqBQOIHw==";
      };
    }
    {
      name = "minimist___minimist_1.2.8.tgz";
      path = fetchurl {
        name = "minimist___minimist_1.2.8.tgz";
        url  = "https://registry.yarnpkg.com/minimist/-/minimist-1.2.8.tgz";
        sha512 = "2yyAR8qBkN3YuheJanUpWC5U3bb5osDywNB8RzDVlDwDHbocAJveqqj1u8+SVD7jkWT4yvsHCpWqqWqAxb0zCA==";
      };
    }
    {
      name = "mkdirp___mkdirp_0.5.6.tgz";
      path = fetchurl {
        name = "mkdirp___mkdirp_0.5.6.tgz";
        url  = "https://registry.yarnpkg.com/mkdirp/-/mkdirp-0.5.6.tgz";
        sha512 = "FP+p8RB8OWpF3YZBCrP5gtADmtXApB5AMLn+vdyA+PyxCjrCs00mjyUozssO33cwDeT3wNGdLxJ5M//YqtHAJw==";
      };
    }
    {
      name = "nanoid___nanoid_3.3.7.tgz";
      path = fetchurl {
        name = "nanoid___nanoid_3.3.7.tgz";
        url  = "https://registry.yarnpkg.com/nanoid/-/nanoid-3.3.7.tgz";
        sha512 = "eSRppjcPIatRIMC1U6UngP8XFcz8MQWGQdt1MTBQ7NaAmvXDfvNxbvWV3x2y6CdEUciCSsDHDQZbhYaB8QEo2g==";
      };
    }
    {
      name = "nice_try___nice_try_1.0.5.tgz";
      path = fetchurl {
        name = "nice_try___nice_try_1.0.5.tgz";
        url  = "https://registry.yarnpkg.com/nice-try/-/nice-try-1.0.5.tgz";
        sha512 = "1nh45deeb5olNY7eX82BkPO7SSxR5SSYJiPTrTdFUVYwAl8CKMA5N9PjTYkHiRjisVcxcQ1HXdLhx2qxxJzLNQ==";
      };
    }
    {
      name = "node_elm_compiler___node_elm_compiler_5.0.6.tgz";
      path = fetchurl {
        name = "node_elm_compiler___node_elm_compiler_5.0.6.tgz";
        url  = "https://registry.yarnpkg.com/node-elm-compiler/-/node-elm-compiler-5.0.6.tgz";
        sha512 = "DWTRQR8b54rvschcZRREdsz7K84lnS8A6YJu8du3QLQ8f204SJbyTaA6NzYYbfUG97OTRKRv/0KZl82cTfpLhA==";
      };
    }
    {
      name = "once___once_1.4.0.tgz";
      path = fetchurl {
        name = "once___once_1.4.0.tgz";
        url  = "https://registry.yarnpkg.com/once/-/once-1.4.0.tgz";
        sha512 = "lNaJgI+2Q5URQBkccEKHTQOPaXdUxnZZElQTZY0MFUAuaEqe1E+Nyvgdz/aIyNi6Z9MzO5dv1H8n58/GELp3+w==";
      };
    }
    {
      name = "p_limit___p_limit_3.1.0.tgz";
      path = fetchurl {
        name = "p_limit___p_limit_3.1.0.tgz";
        url  = "https://registry.yarnpkg.com/p-limit/-/p-limit-3.1.0.tgz";
        sha512 = "TYOanM3wGwNGsZN2cVTYPArw454xnXj5qmWF1bEoAc4+cU/ol7GVh7odevjp1FNHduHc3KZMcFduxU5Xc6uJRQ==";
      };
    }
    {
      name = "p_locate___p_locate_5.0.0.tgz";
      path = fetchurl {
        name = "p_locate___p_locate_5.0.0.tgz";
        url  = "https://registry.yarnpkg.com/p-locate/-/p-locate-5.0.0.tgz";
        sha512 = "LaNjtRWUBY++zB5nE/NwcaoMylSPk+S+ZHNB1TzdbMJMny6dynpAGt7X/tl/QYq3TIeE6nxHppbo2LGymrG5Pw==";
      };
    }
    {
      name = "path_exists___path_exists_4.0.0.tgz";
      path = fetchurl {
        name = "path_exists___path_exists_4.0.0.tgz";
        url  = "https://registry.yarnpkg.com/path-exists/-/path-exists-4.0.0.tgz";
        sha512 = "ak9Qy5Q7jYb2Wwcey5Fpvg2KoAc/ZIhLSLOSBmRmygPsGwkVVt0fZa0qrtMz+m6tJTAHfZQ8FnmB4MG4LWy7/w==";
      };
    }
    {
      name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
      path = fetchurl {
        name = "path_is_absolute___path_is_absolute_1.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
        sha512 = "AVbw3UJ2e9bq64vSaS9Am0fje1Pa8pbGqTTsmXfaIiMpnr5DlDhfJOuLj9Sf95ZPVDAUerDfEk88MPmPe7UCQg==";
      };
    }
    {
      name = "path_key___path_key_2.0.1.tgz";
      path = fetchurl {
        name = "path_key___path_key_2.0.1.tgz";
        url  = "https://registry.yarnpkg.com/path-key/-/path-key-2.0.1.tgz";
        sha512 = "fEHGKCSmUSDPv4uoj8AlD+joPlq3peND+HRYyxFz4KPw4z926S/b8rIuFs2FYJg3BwsxJf6A9/3eIdLaYC+9Dw==";
      };
    }
    {
      name = "picocolors___picocolors_1.0.0.tgz";
      path = fetchurl {
        name = "picocolors___picocolors_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/picocolors/-/picocolors-1.0.0.tgz";
        sha512 = "1fygroTLlHu66zi26VoTDv8yRgm0Fccecssto+MhsZ0D/DGW2sm8E8AjW7NU5VVTRt5GxbeZ5qBuJr+HyLYkjQ==";
      };
    }
    {
      name = "postcss___postcss_8.4.33.tgz";
      path = fetchurl {
        name = "postcss___postcss_8.4.33.tgz";
        url  = "https://registry.yarnpkg.com/postcss/-/postcss-8.4.33.tgz";
        sha512 = "Kkpbhhdjw2qQs2O2DGX+8m5OVqEcbB9HRBvuYM9pgrjEFUg30A9LmXNlTAUj4S9kgtGyrMbTzVjH7E+s5Re2yg==";
      };
    }
    {
      name = "rimraf___rimraf_2.6.3.tgz";
      path = fetchurl {
        name = "rimraf___rimraf_2.6.3.tgz";
        url  = "https://registry.yarnpkg.com/rimraf/-/rimraf-2.6.3.tgz";
        sha512 = "mwqeW5XsA2qAejG46gYdENaxXjx9onRNCfn7L0duuP4hCuTIi/QO7PDK07KJfp1d+izWPrzEJDcSqBa0OZQriA==";
      };
    }
    {
      name = "rollup___rollup_4.9.6.tgz";
      path = fetchurl {
        name = "rollup___rollup_4.9.6.tgz";
        url  = "https://registry.yarnpkg.com/rollup/-/rollup-4.9.6.tgz";
        sha512 = "05lzkCS2uASX0CiLFybYfVkwNbKZG5NFQ6Go0VWyogFTXXbR039UVsegViTntkk4OglHBdF54ccApXRRuXRbsg==";
      };
    }
    {
      name = "semver___semver_5.7.2.tgz";
      path = fetchurl {
        name = "semver___semver_5.7.2.tgz";
        url  = "https://registry.yarnpkg.com/semver/-/semver-5.7.2.tgz";
        sha512 = "cBznnQ9KjJqU67B52RMC65CMarK2600WFnbkcaiwWq3xy/5haFJlshgnpjovMVJ+Hff49d8GEn0b87C5pDQ10g==";
      };
    }
    {
      name = "shebang_command___shebang_command_1.2.0.tgz";
      path = fetchurl {
        name = "shebang_command___shebang_command_1.2.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-command/-/shebang-command-1.2.0.tgz";
        sha512 = "EV3L1+UQWGor21OmnvojK36mhg+TyIKDh3iFBKBohr5xeXIhNBcx8oWdgkTEEQ+BEFFYdLRuqMfd5L84N1V5Vg==";
      };
    }
    {
      name = "shebang_regex___shebang_regex_1.0.0.tgz";
      path = fetchurl {
        name = "shebang_regex___shebang_regex_1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/shebang-regex/-/shebang-regex-1.0.0.tgz";
        sha512 = "wpoSFAxys6b2a2wHZ1XpDSgD7N9iVjg29Ph9uV/uaP9Ex/KXlkTZTeddxDPSYQpgvzKLGJke2UU0AzoGCjNIvQ==";
      };
    }
    {
      name = "source_map_js___source_map_js_1.0.2.tgz";
      path = fetchurl {
        name = "source_map_js___source_map_js_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/source-map-js/-/source-map-js-1.0.2.tgz";
        sha512 = "R0XvVJ9WusLiqTCEiGCmICCMplcCkIwwR11mOSD9CR5u+IXYdiseeEuXCVAjS54zqwkLcPNnmU4OeJ6tUrWhDw==";
      };
    }
    {
      name = "temp___temp_0.9.4.tgz";
      path = fetchurl {
        name = "temp___temp_0.9.4.tgz";
        url  = "https://registry.yarnpkg.com/temp/-/temp-0.9.4.tgz";
        sha512 = "yYrrsWnrXMcdsnu/7YMYAofM1ktpL5By7vZhf15CrXijWWrEYZks5AXBudalfSWJLlnen/QUJUB5aoB0kqZUGA==";
      };
    }
    {
      name = "vite_plugin_elm___vite_plugin_elm_2.9.0.tgz";
      path = fetchurl {
        name = "vite_plugin_elm___vite_plugin_elm_2.9.0.tgz";
        url  = "https://registry.yarnpkg.com/vite-plugin-elm/-/vite-plugin-elm-2.9.0.tgz";
        sha512 = "54gg05COJgzLII3kJFBq7mVTzRTLIktpeoYfguoEBcKB9gh9zYHNHKpjXl2kmaroslq6T/gFsTOMNNBYb9Vf4A==";
      };
    }
    {
      name = "vite___vite_5.0.12.tgz";
      path = fetchurl {
        name = "vite___vite_5.0.12.tgz";
        url  = "https://registry.yarnpkg.com/vite/-/vite-5.0.12.tgz";
        sha512 = "4hsnEkG3q0N4Tzf1+t6NdN9dg/L3BM+q8SWgbSPnJvrgH2kgdyzfVJwbR1ic69/4uMJJ/3dqDZZE5/WwqW8U1w==";
      };
    }
    {
      name = "which___which_1.3.1.tgz";
      path = fetchurl {
        name = "which___which_1.3.1.tgz";
        url  = "https://registry.yarnpkg.com/which/-/which-1.3.1.tgz";
        sha512 = "HxJdYWq1MTIQbJ3nw0cqssHoTNU267KlrDuGZ1WYlxDStUtKUhOaJmh112/TZmHxxUfuJqPXSOm7tDyas0OSIQ==";
      };
    }
    {
      name = "which___which_2.0.2.tgz";
      path = fetchurl {
        name = "which___which_2.0.2.tgz";
        url  = "https://registry.yarnpkg.com/which/-/which-2.0.2.tgz";
        sha512 = "BLI3Tl1TW3Pvl70l3yq3Y64i+awpwXqsGBYWkkqMtnbXgrMD+yj7rhW0kuEDxzJaYXGjEW5ogapKNMEKNMjibA==";
      };
    }
    {
      name = "wrappy___wrappy_1.0.2.tgz";
      path = fetchurl {
        name = "wrappy___wrappy_1.0.2.tgz";
        url  = "https://registry.yarnpkg.com/wrappy/-/wrappy-1.0.2.tgz";
        sha512 = "l4Sp/DRseor9wL6EvV2+TuQn63dMkPjZ/sp9XkghTEbV9KlPS1xUsZ3u7/IQO4wxtcFB4bgpQPRcR3QCvezPcQ==";
      };
    }
    {
      name = "yocto_queue___yocto_queue_0.1.0.tgz";
      path = fetchurl {
        name = "yocto_queue___yocto_queue_0.1.0.tgz";
        url  = "https://registry.yarnpkg.com/yocto-queue/-/yocto-queue-0.1.0.tgz";
        sha512 = "rVksvsnNCdJ/ohGc6xgPwyN8eheCxsiLM8mxuE/t/mOVqJewPuO1miLpTHQiRgTKCLexL4MeAFVagts7HmNZ2Q==";
      };
    }
  ];
}
