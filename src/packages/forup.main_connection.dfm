object main_connection: Tmain_connection
  Height = 418
  Width = 800
  object fupManager: TFDManager
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 336
    Top = 8
  end
  object fupWaitCursor: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 440
    Top = 8
  end
  object fupPostgre: TFDConnection
    LoginPrompt = False
    Left = 336
    Top = 72
  end
  object fupMongo: TFDConnection
    LoginPrompt = False
    Left = 336
    Top = 128
  end
  object fupMySQL: TFDConnection
    LoginPrompt = False
    Left = 336
    Top = 192
  end
  object fupSQLite: TFDConnection
    LoginPrompt = False
    Left = 336
    Top = 256
  end
  object fupPGTransaction: TFDTransaction
    Connection = fupPostgre
    Left = 440
    Top = 72
  end
  object fupMongoTransaction: TFDTransaction
    Connection = fupMongo
    Left = 440
    Top = 128
  end
  object fupMySQLTransaction: TFDTransaction
    Connection = fupMySQL
    Left = 440
    Top = 192
  end
  object fupSQLiteTransaction: TFDTransaction
    Connection = fupSQLite
    Left = 440
    Top = 256
  end
  object fupMySQLLink: TFDPhysMySQLDriverLink
    Left = 248
    Top = 192
  end
  object fupPGLink: TFDPhysPgDriverLink
    Left = 248
    Top = 72
  end
  object fupMongoLink: TFDPhysMongoDriverLink
    Left = 248
    Top = 128
  end
  object fupSQLiteLink: TFDPhysSQLiteDriverLink
    Left = 248
    Top = 256
  end
  object fupPGCommand: TFDCommand
    Connection = fupPostgre
    Left = 568
    Top = 72
  end
  object fupMongoCommand: TFDCommand
    Connection = fupMongo
    Left = 568
    Top = 128
  end
  object fupMySQLCommand: TFDCommand
    Connection = fupMySQL
    Left = 568
    Top = 192
  end
  object fupSQLiteCommand: TFDCommand
    Connection = fupPostgre
    Left = 568
    Top = 256
  end
  object fupPGQryAux: TFDQuery
    Connection = fupPostgre
    Left = 688
    Top = 72
  end
  object fupMongoQryAux: TFDQuery
    Connection = fupMongo
    Left = 688
    Top = 128
  end
  object fupMySQLQryAux: TFDQuery
    Connection = fupPostgre
    Left = 688
    Top = 192
  end
  object fupSQLLiteQryAux: TFDQuery
    Connection = fupPostgre
    Left = 688
    Top = 256
  end
  object fupFirebird: TFDConnection
    LoginPrompt = False
    Left = 336
    Top = 320
  end
  object fupFirebirdTransaction: TFDTransaction
    Connection = fupFirebird
    Left = 440
    Top = 320
  end
  object fupFirebirdCommand: TFDCommand
    Connection = fupPostgre
    Left = 568
    Top = 320
  end
  object fupFirebirdQryAux: TFDQuery
    Connection = fupPostgre
    Left = 688
    Top = 320
  end
  object fupFirebirdLink: TFDPhysFBDriverLink
    Left = 248
    Top = 320
  end
end
