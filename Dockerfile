FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

COPY ./src/DevOpsChallenge.SalesApi/DevOpsChallenge.SalesApi.csproj ./src/DevOpsChallenge.SalesApi/
COPY ./src/DevOpsChallenge.SalesApi.Business/DevOpsChallenge.SalesApi.Business.csproj ./src/DevOpsChallenge.SalesApi.Business/
COPY ./src/DevOpsChallenge.SalesApi.Database/DevOpsChallenge.SalesApi.Database.csproj ./src/DevOpsChallenge.SalesApi.Database/

RUN dotnet restore ./src/DevOpsChallenge.SalesApi/DevOpsChallenge.SalesApi.csproj

COPY . .

RUN dotnet publish ./src/DevOpsChallenge.SalesApi/DevOpsChallenge.SalesApi.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

EXPOSE 8080

ENTRYPOINT ["dotnet", "DevOpsChallenge.SalesApi.dll"]
