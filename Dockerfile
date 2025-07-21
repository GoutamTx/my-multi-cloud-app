# Use a lightweight Nginx image
FROM nginx:alpine

# Copy your HTML/CSS files into the Nginx default directory
COPY ./src/ /usr/share/nginx/html

# Expose port 80 (Nginx default)
EXPOSE 80

# Command to run Nginx (default command of the base image)
CMD ["nginx", "-g", "daemon off;"]
