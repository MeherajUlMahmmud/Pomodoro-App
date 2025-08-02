import 'package:flutter/material.dart';
import 'package:pomodoro/services/sync_service.dart';
import 'package:pomodoro/services/connectivity_service.dart';

class SyncStatusWidget extends StatefulWidget {
  const SyncStatusWidget({super.key});

  @override
  State<SyncStatusWidget> createState() => _SyncStatusWidgetState();
}

class _SyncStatusWidgetState extends State<SyncStatusWidget> {
  final SyncService _syncService = SyncService();
  final ConnectivityService _connectivityService = ConnectivityService();

  bool _isOnline = true;
  bool _isSyncing = false;
  int _pendingItems = 0;
  DateTime? _lastSyncTime;

  @override
  void initState() {
    super.initState();
    _loadSyncStatus();
    _listenToConnectivity();
  }

  Future<void> _loadSyncStatus() async {
    final isOnline = await _connectivityService.hasInternetConnection();
    final pendingItems = await _syncService.getSyncQueueSize();
    final lastSyncTime = await _syncService.getLastSyncTime();

    if (mounted) {
      setState(() {
        _isOnline = isOnline;
        _pendingItems = pendingItems;
        _lastSyncTime = lastSyncTime;
      });
    }
  }

  void _listenToConnectivity() {
    _connectivityService.connectivityStream.listen((status) {
      final isOnline = status == ConnectivityStatus.connected;
      if (mounted) {
        setState(() {
          _isOnline = isOnline;
        });

        // Auto-sync when internet becomes available
        if (isOnline) {
          _performSync();
        }
      }
    });
  }

  Future<void> _performSync() async {
    if (!_isOnline || _isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      await _syncService.processSyncQueue();
      await _loadSyncStatus();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data synchronized successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isOnline ? Icons.cloud_done : Icons.cloud_off,
                  color: _isOnline ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Sync Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (_isSyncing)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Online/Offline status
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _isOnline ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: _isOnline ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Pending items
            if (_pendingItems > 0) ...[
              Row(
                children: [
                  const Icon(Icons.pending, size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    '$_pendingItems items pending sync',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Last sync time
            if (_lastSyncTime != null) ...[
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Last sync: ${_formatLastSyncTime(_lastSyncTime!)}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            // Sync button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isOnline && !_isSyncing ? _performSync : null,
                icon: const Icon(Icons.sync),
                label: Text(_isSyncing ? 'Syncing...' : 'Sync Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isOnline ? Theme.of(context).primaryColor : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastSyncTime(DateTime lastSyncTime) {
    final now = DateTime.now();
    final difference = now.difference(lastSyncTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
