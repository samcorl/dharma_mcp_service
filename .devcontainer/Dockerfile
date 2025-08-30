FROM mcr.microsoft.com/devcontainers/ruby:1-3.2-bullseye

# Install additional packages for Ruby development
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        # Database clients
        mysql-client \
        # Build tools
        build-essential \
        libmysqlclient-dev \
        pkg-config \
        # Node.js for asset pipeline (if needed)
        nodejs \
        npm \
        # Development tools
        vim \
        curl \
        wget \
        git \
        htop \
        # Ruby development tools
        ruby-dev \
        # For debugging and testing
        gdb \
        strace \
        # SSL certificates
        ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install global npm packages
RUN npm install -g yarn

# Install useful Ruby gems globally
RUN gem update --system \
    && gem install \
        bundler \
        rails \
        pry \
        pry-doc \
        rubocop \
        brakeman \
        solargraph

# Set up Ruby environment
ENV GEM_HOME="/usr/local/bundle"
ENV PATH="$GEM_HOME/bin:$PATH"
ENV BUNDLE_SILENCE_ROOT_WARNING=1

# Set up the working directory
WORKDIR /workspaces/dharma_mcp_service

# Create vscode user with proper permissions
RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid vscode --shell /bin/bash --create-home vscode \
    && echo vscode ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode \
    && mkdir -p /usr/local/bundle \
    && chown -R vscode:vscode /usr/local/bundle

# Switch to vscode user
USER vscode

# Set up shell environment for Ruby development
RUN echo 'export PATH="$GEM_HOME/bin:$PATH"' >> ~/.bashrc \
    && echo 'alias be="bundle exec"' >> ~/.bashrc \
    && echo 'alias rc="rails console"' >> ~/.bashrc \
    && echo 'alias rs="rails server"' >> ~/.bashrc \
    && echo 'alias rt="rails test"' >> ~/.bashrc \
    && echo 'alias rdb="rails db"' >> ~/.bashrc

# Set up Git (will be overridden by user's git config)
RUN git config --global init.defaultBranch main \
    && git config --global core.autocrlf input