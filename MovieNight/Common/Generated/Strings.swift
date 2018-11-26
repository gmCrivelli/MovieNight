// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum Localization {
  /// Add Movie
  internal static let addMovie = Localization.tr("Localizable", "ADD_MOVIE")
  /// Picture Library
  internal static let album = Localization.tr("Localizable", "ALBUM")
  /// Attention!
  internal static let attention = Localization.tr("Localizable", "ATTENTION")
  /// Autoplay Movie Trailers
  internal static let autoplayTrailers = Localization.tr("Localizable", "AUTOPLAY_TRAILERS")
  /// Camera
  internal static let camera = Localization.tr("Localizable", "CAMERA")
  /// Cancel
  internal static let cancel = Localization.tr("Localizable", "CANCEL")
  /// Categories
  internal static let categories = Localization.tr("Localizable", "CATEGORIES")
  /// Adventure, Comedy, Nonsense
  internal static let categoriesPlaceholder = Localization.tr("Localizable", "CATEGORIES_PLACEHOLDER")
  /// Create reminder
  internal static let createReminder = Localization.tr("Localizable", "CREATE_REMINDER")
  /// Dark
  internal static let dark = Localization.tr("Localizable", "DARK")
  /// Whoops! Something went wrong. Please try again later.
  internal static let defaultError = Localization.tr("Localizable", "DEFAULT_ERROR")
  /// Delete Movie
  internal static let deleteMovie = Localization.tr("Localizable", "DELETE_MOVIE")
  /// Are you sure you want to delete this movie? This action may not be undone.
  internal static let deleteMovieCheck = Localization.tr("Localizable", "DELETE_MOVIE_CHECK")
  /// Duration
  internal static let duration = Localization.tr("Localizable", "DURATION")
  /// Edit
  internal static let edit = Localization.tr("Localizable", "EDIT")
  /// Edit Movie
  internal static let editMovie = Localization.tr("Localizable", "EDIT_MOVIE")
  /// Edit poster
  internal static let editPoster = Localization.tr("Localizable", "EDIT_POSTER")
  /// Error
  internal static let error = Localization.tr("Localizable", "ERROR")
  /// Whoops! Check if your internet connection is active.
  internal static let internalError = Localization.tr("Localizable", "INTERNAL_ERROR")
  /// Light
  internal static let light = Localization.tr("Localizable", "LIGHT")
  /// Movie
  internal static let movie = Localization.tr("Localizable", "MOVIE")
  /// Movie Poster
  internal static let moviePoster = Localization.tr("Localizable", "MOVIE_POSTER")
  /// Select movie poster from:
  internal static let moviePosterMessage = Localization.tr("Localizable", "MOVIE_POSTER_MESSAGE")
  /// Movie Title
  internal static let movieTitle = Localization.tr("Localizable", "MOVIE_TITLE")
  /// Monty Python and the Holy Grail
  internal static let movieTitlePlaceholder = Localization.tr("Localizable", "MOVIE_TITLE_PLACEHOLDER")
  /// Movies
  internal static let movies = Localization.tr("Localizable", "MOVIES")
  /// Napolitan
  internal static let napolitan = Localization.tr("Localizable", "NAPOLITAN")
  /// New Releases
  internal static let newReleases = Localization.tr("Localizable", "NEW_RELEASES")
  /// No category
  internal static let noCategories = Localization.tr("Localizable", "NO_CATEGORIES")
  /// No registered movies... yet!
  internal static let noMovies = Localization.tr("Localizable", "NO_MOVIES")
  /// No rating!
  internal static let noRating = Localization.tr("Localizable", "NO_RATING")
  /// No summary!
  internal static let noSummary = Localization.tr("Localizable", "NO_SUMMARY")
  /// Whoops! Could not find the trailer for this movie.
  internal static let notFoundError = Localization.tr("Localizable", "NOT_FOUND_ERROR")
  /// Just passing by to remind you: Go watch 
  internal static let notificationBodyFirst = Localization.tr("Localizable", "NOTIFICATION_BODY_FIRST")
  /// ! Have fun :)
  internal static let notificationBodySecond = Localization.tr("Localizable", "NOTIFICATION_BODY_SECOND")
  /// 🍿 Grab your popcorn, it's movie time!
  internal static let notificationTitle = Localization.tr("Localizable", "NOTIFICATION_TITLE")
  /// OK
  internal static let ok = Localization.tr("Localizable", "OK")
  /// Permission needed
  internal static let permissionNeeded = Localization.tr("Localizable", "PERMISSION_NEEDED")
  /// To receive reminders, please allow the usage of notifications in your device settings.
  internal static let permissionNeededMessage = Localization.tr("Localizable", "PERMISSION_NEEDED_MESSAGE")
  /// Rating
  internal static let rating = Localization.tr("Localizable", "RATING")
  /// Reminder
  internal static let reminder = Localization.tr("Localizable", "REMINDER")
  /// Set reminder ⏰
  internal static let reminderButton = Localization.tr("Localizable", "REMINDER_BUTTON")
  /// Select a date and time to be reminded to watch the movie!
  internal static let reminderMessage = Localization.tr("Localizable", "REMINDER_MESSAGE")
  /// Settings
  internal static let settings = Localization.tr("Localizable", "SETTINGS")
  /// Summary:
  internal static let summary = Localization.tr("Localizable", "SUMMARY")
  /// Theme
  internal static let theme = Localization.tr("Localizable", "THEME")
  /// Understood!
  internal static let understood = Localization.tr("Localizable", "UNDERSTOOD")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension Localization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
