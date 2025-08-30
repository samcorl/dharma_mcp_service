FROM mcr.microsoft.com/devcontainers/ruby:1-3.2-bullseye

# Install additional packages for Ruby development
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends \
  # Database clients
  default-mysql-client \
  # Build tools
  build-essential \
  libmariadb-dev-compat \
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
WORKDIR /workspaces

# Setup bundle directory permissions for existing vscode user
RUN mkdir -p /usr/local/bundle \
  && chown -R vscode:vscode /usr/local/bundle

# Setup Claude Code directory with proper permissions
RUN mkdir -p /home/vscode/.config/claude-code \
  && chown -R vscode:vscode /home/vscode/.config/claude-code \
  && chmod -R 755 /home/vscode/.config/claude-code

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

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