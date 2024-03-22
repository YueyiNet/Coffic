import 'package:cisum/entities/audio.dart';
import 'package:cisum/entities/database.dart';
import 'package:cisum/entities/logger.dart';
import 'package:cisum/entities/playlist.dart';
import 'package:cisum/provider/player.dart';
import 'package:cisum/views/database/database_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DatabaseTable extends StatefulWidget {
  const DatabaseTable({super.key, required this.playlist});

  final PlaylistModel playlist;

  @override
  State<DatabaseTable> createState() => _DatabaseTableState();
}

class _DatabaseTableState extends State<DatabaseTable> {
  @override
  Widget build(BuildContext context) {
    var current = context.select<PlayerProvider, AudioModel>((value) => value.getAudio());

    logger.d("构建 DataTable");

    return makeTable(widget.playlist, current);
  }

  makeTable(PlaylistModel playlist, AudioModel current) {
    return DataTable(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      horizontalMargin: 12,
      headingRowColor: MaterialStateProperty.all(Colors.black12),
      headingTextStyle: const TextStyle(fontSize: 12),
      headingRowHeight: 0,
      showCheckboxColumn: false,
      dataRowMinHeight: 24,
      dataRowMaxHeight: 24,
      dataTextStyle: const TextStyle(fontSize: 12),
      columns: const [
        DataColumn(label: Text('歌曲')),
      ],
      rows: makeRows(playlist, current),
    );
  }

  makeRows(PlaylistModel playlist, AudioModel current) {
    return playlist.audios
        .map((audio) => DataRow(
                selected: current.sameTo(audio),
                onLongPress: () {
                  logger.d("onLongPress: ${audio.file.path}");
                },
                onSelectChanged: (value) {
                  context.read<PlayerProvider>().play(audio: audio);
                },
                cells: [
                  DataCell(
                    DatabaseCell(audio: audio),
                  )
                ]))
        .toList();
  }
}
