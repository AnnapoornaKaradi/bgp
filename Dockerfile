# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# This stage is used when running from VS in fast mode (Default for Debug configuration)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080


# This stage is used to build the service project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["src/Services/Fnf.SalesInHere.Services.ApiGateway/Fnf.SalesInHere.Services.ApiGateway.csproj", "src/Services/Fnf.SalesInHere.Services.ApiGateway/"]
COPY ["src/Common/Fnf.SalesInHere.Common.ApiAuthorization/Fnf.SalesInHere.Common.ApiAuthorization.csproj", "src/Common/Fnf.SalesInHere.Common.ApiAuthorization/"]
COPY ["src/Common/Fnf.SalesInHere.Common.Helpers/Fnf.SalesInHere.Common.Helpers.csproj", "src/Common/Fnf.SalesInHere.Common.Helpers/"]
COPY ["src/Common/Fnf.SalesInHere.Common.SwaggerExtension/Fnf.SalesInHere.Common.SwaggerExtension.csproj", "src/Common/Fnf.SalesInHere.Common.SwaggerExtension/"]
RUN dotnet restore "./src/Services/Fnf.SalesInHere.Services.ApiGateway/Fnf.SalesInHere.Services.ApiGateway.csproj"
COPY . .
WORKDIR "/src/src/Services/Fnf.SalesInHere.Services.ApiGateway"
RUN dotnet build "./Fnf.SalesInHere.Services.ApiGateway.csproj" -c $BUILD_CONFIGURATION -o /app/build

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Fnf.SalesInHere.Services.ApiGateway.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Fnf.SalesInHere.Services.ApiGateway.dll"]