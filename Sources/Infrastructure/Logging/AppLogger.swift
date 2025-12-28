import OSLog

/// Centralized logging infrastructure using Apple's OSLog framework.
///
/// This extension provides category-specific loggers for different subsystems
/// of the ClaudeBar application. Each logger is configured with the app's
/// bundle identifier as the subsystem and a specific category for filtering.
///
/// ## Usage Examples
///
/// ```swift
/// // Monitor operations
/// Logger.monitor.info("Starting refresh for \(providers.count) providers")
/// Logger.monitor.debug("Provider \(id, privacy: .public) completed refresh")
///
/// // Probe execution
/// Logger.probes.debug("Executing Claude CLI probe")
/// Logger.probes.trace("Raw CLI output: \(output, privacy: .private)")
/// Logger.probes.error("CLI probe failed: \(error.localizedDescription)")
///
/// // Sensitive data (ALWAYS use privacy annotations)
/// Logger.credentials.debug("Token hash: \(token, privacy: .private(mask: .hash))")
/// Logger.network.debug("API request to: \(url, privacy: .public)")
/// ```
///
/// ## Privacy Guidelines
///
/// - **Public data** (`.public`): Safe to log (provider names, status enums, counts)
/// - **Private data** (`.private`): Redacted in logs (tokens, API keys, usernames, CLI output)
/// - **Hash masking** (`.private(mask: .hash)`): Shows hash for correlation without exposing value
///
/// ## Log Levels
///
/// - **Trace/Debug**: Development diagnostics (memory-only, not persisted)
/// - **Info**: Informational messages (persisted only with `log collect`)
/// - **Notice**: Significant events (always persisted)
/// - **Error/Fault**: Errors and critical failures (always persisted)
///
/// ## Viewing Logs
///
/// Use Console.app with filter: `subsystem:com.tddworks.ClaudeBar`
/// Or use `log` command:
/// ```bash
/// log show --predicate 'subsystem == "com.tddworks.ClaudeBar"' --last 1h
/// ```
public extension Logger {
    /// The app's bundle identifier used as the logging subsystem
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.tddworks.ClaudeBar"
    
    /// Logger for quota monitoring operations
    ///
    /// Use for: Monitor lifecycle, refresh operations, provider coordination
    static let monitor = Logger(subsystem: subsystem, category: "monitor")
    
    /// Logger for AI provider operations
    ///
    /// Use for: Provider lifecycle, state changes, snapshot updates
    static let providers = Logger(subsystem: subsystem, category: "providers")
    
    /// Logger for usage probe operations
    ///
    /// Use for: CLI execution, probe results, parsing operations
    /// Note: Always use `.private` for raw CLI output
    static let probes = Logger(subsystem: subsystem, category: "probes")
    
    /// Logger for network operations
    ///
    /// Use for: API requests, HTTP responses, network errors
    /// Note: Use `.public` for URLs, `.private` for response bodies
    static let network = Logger(subsystem: subsystem, category: "network")
    
    /// Logger for credential operations
    ///
    /// Use for: Token management, credential storage, authentication
    /// Note: ALWAYS use `.private` or `.private(mask: .hash)` for sensitive data
    static let credentials = Logger(subsystem: subsystem, category: "credentials")
    
    /// Logger for UI operations
    ///
    /// Use for: View lifecycle, user interactions, UI state changes
    static let ui = Logger(subsystem: subsystem, category: "ui")
    
    /// Logger for notification operations
    ///
    /// Use for: Permission requests, notification delivery, status changes
    static let notifications = Logger(subsystem: subsystem, category: "notifications")
    
    /// Logger for update operations
    ///
    /// Use for: Sparkle updates, version checks, update installations
    static let updates = Logger(subsystem: subsystem, category: "updates")
}
