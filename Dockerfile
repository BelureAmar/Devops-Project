FROM nginx:stable-alpine

# Copy your local static website files to the default Nginx HTML directory
COPY ./html /usr/share/nginx/html

# Optional: Copy a custom configuration file if you need one
# COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx in the foreground so the container stays running
CMD ["nginx", "-g", "daemon off;"]
