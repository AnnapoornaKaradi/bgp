// <copyright file="Program.cs" company="FNF">
// Copyright (c) FNF. All rights reserved.
// </copyright>.
using System.Diagnostics.CodeAnalysis;
using Fnf.SalesInHere.Services.ApiGateway.Extensions;

namespace Fnf.SalesInHere.Services.ApiGateway;

/// <summary>
/// Program
/// </summary>
[ExcludeFromCodeCoverage]
public static class Program
{
    /// <summary>
    /// Defines the entry point of the application.
    /// </summary>
    /// <param name="args">The arguments.</param>
    private static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        _ = builder.Host.AddConfiguration();

        // Disables endpoint override warning message when using IConfiguration for Kestrel endpoint.
        _ = builder.WebHost.UseUrls();
        _ = builder.Services.AddCorsForApiAccess(builder.Configuration);

        _ = builder.Services.AddOutputCaching();

        _ = builder.Services.AddHealthChecks();

        // Add services to the container.
        _ = builder.Services.AddReverseProxy()
            .LoadFromConfig(builder.Configuration.GetSection("ReverseProxy"));

        var app = builder.Build();

        // Configure the HTTP request pipeline.
        _ = app.UseCors();
        _ = app.UseOutputCache();
        _ = app.MapHealthChecks("/_health");
        _ = app.MapReverseProxy();

        _ = app.MapGet("/", () =>
        {
            return Results.Ok("API Gateway Running...");
        });

        app.Run();
    }
}
