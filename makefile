# ================== 架构选择 ==================
# 默认在 PC（x86_64）上编译
# 如果要交叉编译到 i.MX6ULL（ARM），使用：
# make ARCH=arm

ARCH ?= x86_64

# 根据架构选择编译器
ifeq ($(ARCH), arm)
    CXX = arm-linux-gnueabihf-g++   # ARM 交叉编译器（用于 i.MX6ULL）
else
    CXX = g++                       # PC 本地编译器
endif

# ================== 编译选项 ==================
# DEBUG=1：调试模式（带符号信息，方便 gdb）
# DEBUG=0：发布模式（优化代码）

DEBUG ?= 1

ifeq ($(DEBUG), 1)
    CXXFLAGS += -g -Wall            # -g：调试信息，-Wall：开启警告
else
    CXXFLAGS += -O2                 # 优化编译，提高运行效率
endif

# ================== 是否启用 SQLite ==================
# 默认启用 SQLite，编译时会链接 sqlite3 库。
# 如果你在目标平台上不需要数据库功能，可将下面的 LIBS 修改为仅 -lpthread。

LIBS = -lpthread -lsqlite3

# ================== 源文件列表 ==================
# WebServer 核心模块

SRC = main.cpp \
      ./timer/lst_timer.cpp \
      ./http/http_conn.cpp \
      ./log/log.cpp \
      webserver.cpp \
      config.cpp

# ================== 目标文件 ==================

TARGET = server

# ================== 编译规则 ==================
# $@ 表示目标（server）
# $^ 表示所有依赖文件（SRC）

$(TARGET): $(SRC)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LIBS)

# ================== 清理 ==================
# 删除生成的可执行文件

clean:
	rm -f $(TARGET)