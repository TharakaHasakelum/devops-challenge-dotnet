# Use the official .NET 8 SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the project files to the container
COPY ./src/DevOpsChallenge.SalesApi/DevOpsChallenge.SalesApi.csproj ./src/DevOpsChallenge.SalesApi/
COPY ./src/DevOpsChallenge.SalesApi.Business/DevOpsChallenge.SalesApi.Business.csproj ./src/DevOpsChallenge.SalesApi.Business/
COPY ./src/DevOpsChallenge.SalesApi.Database/DevOpsChallenge.SalesApi.Database.csproj ./src/DevOpsChallenge.SalesApi.Database/

# Restore the dependencies
RUN dotnet restore ./src/DevOpsChallenge.SalesApi/DevOpsChallenge.SalesApi.csproj

# Copy all the files to the working directory
COPY . .

# Build the application
RUN dotnet publish ./src/DevOpsChallenge.SalesApi/DevOpsChallenge.SalesApi.csproj -c Release -o /app/publish

# Use the official .NET 8 ASP.NET Core runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Set the working directory in the container
WORKDIR /app

# Copy the built files from the build stage
COPY --from=build /app/publish .

# Set environment variables
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Expose port 8080
EXPOSE 8080

# Run the application
ENTRYPOINT ["dotnet", "DevOpsChallenge.SalesApi.dll"]
