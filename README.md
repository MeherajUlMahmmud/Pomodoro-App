# Pomodoro Timer App 🍅

A modern, feature-rich Pomodoro timer application built with Flutter that helps you stay focused and productive using the Pomodoro Technique.

## ✨ Features

### 🎯 Core Timer Functionality
- **Work Sessions**: 25-minute focused work periods
- **Short Breaks**: 5-minute breaks between work sessions
- **Long Breaks**: 15-minute breaks after 4 work sessions
- **Customizable Durations**: Adjust timer lengths in settings
- **Auto-start Options**: Automatically start breaks or work sessions
- **Session Tracking**: Complete session history and statistics

### 📊 Advanced Statistics & Analytics
- **Real-time Progress**: Track daily, weekly, and overall productivity
- **Session Analytics**: View work vs break time distribution
- **Interactive Charts**: Beautiful visualizations of your productivity data
- **Completion Rates**: Monitor session completion success
- **Trend Analysis**: Identify productivity patterns over time

### ✅ Task Management System
- **Task Creation**: Add tasks with descriptions, categories, and priorities
- **Pomodoro Integration**: Associate tasks with estimated pomodoro sessions
- **Progress Tracking**: Visual progress indicators for each task
- **Priority Levels**: High, Medium, Low priority system
- **Task Categories**: Organize tasks by work, study, personal, etc.
- **Overdue Alerts**: Get notified about overdue tasks
- **Task Completion**: Mark tasks as complete and track progress

### 🔔 Smart Notifications & UX
- **Session Completion Alerts**: Get notified when sessions end
- **Haptic Feedback**: Tactile feedback for better interaction
- **Achievement System**: Unlock achievements for consistency
- **Streak Tracking**: Celebrate productivity streaks
- **Motivational Messages**: Encouraging notifications and feedback

### 🎨 Modern UI/UX Design
- **Material 3 Design**: Latest Material Design principles
- **Beautiful Gradients**: Eye-catching color schemes
- **Smooth Animations**: Fluid transitions and interactions
- **Responsive Layout**: Works perfectly on all screen sizes
- **Dark/Light Theme Support**: Comfortable viewing in any lighting
- **Accessibility**: Screen reader support and high contrast options

### ⚙️ Customizable Settings
- **Timer Durations**: Customize work, short break, and long break times
- **Auto-start Preferences**: Choose when to automatically start sessions
- **Sound Settings**: Enable/disable haptic feedback and notifications
- **Long Break Intervals**: Adjust when long breaks occur
- **Data Management**: Export, backup, and clear your data

### 🔐 Authentication & Security
- **Firebase Integration**: Secure user authentication
- **Google Sign-in**: Quick and easy login
- **Data Privacy**: Your data stays on your device
- **Secure Storage**: Encrypted local data storage

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.2.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Firebase project (for authentication)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/pomodoro-app.git
   cd pomodoro-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project
   - Add your Android/iOS apps
   - Download and add the configuration files
   - Enable Google Sign-in authentication

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── session.dart          # Pomodoro session model
│   └── task.dart            # Task management model
├── services/
│   ├── session_service.dart  # Session data management
│   ├── task_service.dart     # Task data management
│   └── notification_service.dart # Notifications & alerts
├── screens/
│   ├── auth_screens/
│   │   └── LoginScreen.dart  # Authentication screen
│   ├── main_screens/
│   │   ├── HomeScreen.dart   # Main timer interface
│   │   ├── TasksScreen.dart  # Task management
│   │   └── StatisticsScreen.dart # Analytics & charts
│   └── utility_screens/
│       ├── SettingsScreen.dart # App settings
│       └── SplashScreen.dart # Loading screen
├── utils/
│   ├── colors.dart          # Color definitions
│   ├── theme.dart           # App theme configuration
│   └── routes_handler.dart  # Navigation routing
└── widgets/
    └── custom_*.dart        # Reusable UI components
```

## 🎯 How to Use

### Starting Your First Session
1. Open the app and sign in
2. Choose your session type (Work, Short Break, or Long Break)
3. Tap the session card to start the timer
4. Focus on your work during the session
5. Take breaks when the timer completes

### Managing Tasks
1. Tap the task icon in the top bar
2. Add new tasks with the + button
3. Set priority, estimated pomodoros, and category
4. Track progress as you complete pomodoros
5. Mark tasks as complete when finished

### Viewing Statistics
1. Tap the chart icon in the top bar
2. View your productivity data
3. Analyze patterns and trends
4. Celebrate your achievements

### Customizing Settings
1. Tap the settings icon
2. Adjust timer durations
3. Configure auto-start preferences
4. Manage notifications and sounds

## 🔧 Technical Features

### Data Persistence
- **SharedPreferences**: Local data storage
- **JSON Serialization**: Efficient data handling
- **Offline Support**: Works without internet connection

### State Management
- **setState**: Simple and effective state management
- **Future-based Operations**: Async data handling
- **Error Handling**: Graceful error recovery

### Performance Optimizations
- **Lazy Loading**: Efficient data loading
- **Memory Management**: Proper disposal of resources
- **Smooth Animations**: 60fps performance

## 🎨 Design System

### Color Palette
- **Primary**: #527E5C (Forest Green)
- **Secondary**: #2196F3 (Blue)
- **Accent**: #FF9800 (Orange)
- **Success**: #4CAF50 (Green)
- **Warning**: #FF9800 (Orange)
- **Error**: #F44336 (Red)

### Typography
- **Headings**: Roboto Bold
- **Body**: Roboto Regular
- **Captions**: Roboto Light

### Spacing
- **8px Grid System**: Consistent spacing throughout
- **16px Margins**: Standard content margins
- **24px Sections**: Clear content separation

## 🚀 Recent Improvements

### Version 2.0 - Major Enhancement
- ✅ **Fixed Critical Bug**: Timer variant buttons now use correct duration
- ✅ **Real Session Tracking**: Complete session history and analytics
- ✅ **Task Management**: Full-featured task system with priorities
- ✅ **Modern UI**: Material 3 design with beautiful gradients
- ✅ **Smart Notifications**: Context-aware alerts and feedback
- ✅ **Data Persistence**: Reliable local data storage
- ✅ **Statistics Dashboard**: Real productivity insights
- ✅ **Customizable Settings**: Flexible timer and notification options
- ✅ **Better UX**: Improved navigation and user flow
- ✅ **Performance**: Optimized for smooth operation

### Bug Fixes
- Fixed timer duration bug in session selection
- Improved Firebase initialization error handling
- Enhanced notification service reliability
- Better error handling throughout the app

### New Features
- Task management with priorities and categories
- Real-time session tracking and analytics
- Interactive charts and statistics
- Achievement and streak system
- Auto-start session options
- Haptic feedback and notifications
- Modern Material 3 design
- Comprehensive settings management

## 🤝 Contributing

We welcome contributions! Please feel free to submit a Pull Request.

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Pomodoro Technique**: Francesco Cirillo for the productivity method
- **Flutter Team**: For the amazing framework
- **Material Design**: For the design system
- **Open Source Community**: For the libraries and tools

## 📞 Support

If you have any questions or need help:
- Create an issue on GitHub
- Check the documentation
- Review the code comments

---

**Happy Productivity! 🍅✨**
