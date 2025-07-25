// <copyright file="Program.cs" company="FNF">
// Copyright (c) FNF. All rights reserved.
// </copyright>.

using Fnf.SalesInHere.Common.Diagnostics;
using Fnf.SalesInHere.Common.PulseAPIWrapper;
using Fnf.SalesInHere.Connectors.Dapr;
using Fnf.SalesInHere.Connectors.HybridCache;
using Fnf.SalesInHere.Services.BackgroundProcessor;
using Fnf.SalesInHere.Services.BackgroundProcessor.Endpoints;
using Fnf.SalesInHere.Services.Base.Helpers;
using Fnf.SalesInHere.Services.Base.Models;

var builder = WebApplication.CreateBuilder(args);

_ = builder.Host.AddConfiguration();

_ = builder.UseLogger();

// Disables endpoint override warning message when using IConfiguration for Kestrel endpoint.
_ = builder.WebHost.UseUrls();
_ = builder.Services.AddCorsForApiAccess(builder.Configuration);

// Health check
_ = builder.Services.AddHealthChecks();

// Add API versionning
_ = builder.Services.AddProblemDetails();

_ = builder.Services.AddDaprServices();
_ = builder.Services.AddPulseApiServices(builder.Configuration);

// Init Redis Cache
RedisConnectionMultiplexer.Initialize(builder.Configuration);

_ = builder.Services.AddHybridCacheStoreWithRedis(
    new HybridCacheStoreOptions { CacheKeyPrefix = "sinh-app", MaxCacheSizeMB = 10 },
    RedisConnectionMultiplexer.Instance);

builder.Services.AddHealthChecks();

var app = builder.Build();

_ = app.UseRouting();
_ = app.UseCors();

// Dapr subscriptions
app.UseCloudEvents();
app.UseEndpoints(endpoints =>
{
    _ = endpoints.MapSubscribeHandler();
});

_ = app.MapHealthChecks("/_health");

var pubsubComponentName = builder.Configuration["ServiceBusOptions:DaprComponentName"];
var pulseCacheRequestTopic = builder.Configuration["ServiceBusOptions:PulseCacheRequestTopic"];

app.MapPost("api/pulse-caching-request", PulseCachingApi.PulseCachingAsync)
    .Accepts<PulseCachingRequest>(BaseApi.ContentType)
    .WithTopic(pubsubComponentName, pulseCacheRequestTopic);

await app.RunAsync().ConfigureAwait(false);
