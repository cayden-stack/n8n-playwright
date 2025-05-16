# Use the official n8n base image
FROM n8nio/n8n:latest

# Switch to root user to install necessary system libraries
USER root
# --> This is a command-line instruction run by Railway during the build:
RUN apt-get update -qq && apt-get install -qq -y --no-install-recommends \
    libatk-bridge2.0-0 \
    libgbm-dev \
    libasound2 \
    libfontconfig1 \
    libjpeg-turbo8 \
    libwebp6 \
    && rm -rf /var/lib/apt/lists/*

# Switch back to the 'node' user
USER node

# Set the working directory
WORKDIR /home/node

# --> This is a command-line instruction run by Railway during the build:
#     It installs the Playwright library itself.
RUN npm install -g playwright

# --> This is a command-line instruction run by Railway during the build:
#     It downloads the actual browser files (Chromium, Firefox, WebKit).
RUN npx playwright install --with-deps

# Optional: Set NODE_PATH if needed (less of a direct command line, more of an environment setting)
# ENV NODE_PATH="/usr/local/lib/node_modules"

# Keep the original n8n entrypoint and command
ENTRYPOINT ["/entrypoint.sh"]
CMD ["n8n"]