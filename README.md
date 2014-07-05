# Common.Logger.Serilog.StructuredText

This is a fork of [Common.Logging.Serilog 1.1.0](https://github.com/CaptiveAire/Common.Logging.Serilog)

It is a Common.Logging adapter for Serilog.

The difference with Common.Logging.Serilog is that with this package, if you log a string containing a valid JSON object,
this package will deserialize that string and send the structured object to Serilog. If the string does not contain a valid JSON object,
it will simply be logged as is.

For example:

```
ILog log1 = LogManager.GetLogger("logger1");

// Logged as structured object
log1.Warn("{ x: 5, y: 8}");

// Logged as is
log1.Warn("hello world");
```

Common.Logging allows you to log an object. Why not just log an object rather than a string?

The problem is that many Common.Logging adapters do not correctly log objects. Instead of properly serializing them, 
they simply apply ToString to the object. This results in the type of the object being logged, rather than its contents.
So unless you know for sure that you'll always log to Serilog, it is safest to log strings rather than objects.

## Usage

### 1. Prerequisites

This package assumes you have already installed Serilog. Specifically, 
you must configure and provide a global logger to use this adapter:

```
var log = new LoggerConfiguration()
    .WriteTo.ColoredConsole()
    .CreateLogger();

// set global instance of Serilog logger which Common.Logger.Serilog requires.
Log.Logger = log;
```

### 2. Install

[Install Common.Logging.Serilog.StructuredText](https://www.nuget.org/packages/Common.Logging.Serilog.StructuredText/)

### 3. Configure

Configure app.config/web.config file of your project:

```
<configSections>
	<sectionGroup name="common">
		<section name="logging" type="Common.Logging.ConfigurationSectionHandler, Common.Logging" />
	</sectionGroup>
</configSections>

<common>
	<logging>
  		<factoryAdapter type="Common.Logging.Serilog.SerilogFactoryAdapter, Common.Logging.Serilog" />
	</logging>
</common>
```

## Links

* [Common Logging](http://netcommon.sourceforge.net/ "Common Infrastructure Libraries for .NET")
* [Serilog Project](http://serilog.net/ "Serilog")