# ===== Stage 2: 构建后端 =====
FROM 	docker.m.daocloud.io/rust:latest

WORKDIR /app

RUN mkdir .cargo
COPY .cargo/config.toml .cargo/config.toml

# 先复制依赖文件，利用 Docker 缓存
COPY Cargo.toml Cargo.lock* ./

# 创建空的 src 目录用于预编译依赖
RUN mkdir src && echo "fn main() {}" > src/main.rs

# 复制后端源码和前端构建产物（rust-embed 在编译时嵌入）
COPY src/ src/

# 触发重新编译（依赖已缓存，只编译项目代码）
RUN cargo build --release

EXPOSE 7452

ENTRYPOINT ["/app/target/release/devops-github-webhook"]
