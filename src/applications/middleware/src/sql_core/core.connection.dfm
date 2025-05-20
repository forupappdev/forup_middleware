object connCore: TconnCore
  Height = 298
  Width = 640
  object ConnManager: TFDManager
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 40
    Top = 16
  end
  object MySQL_Driver: TFDPhysMySQLDriverLink
    Left = 568
    Top = 8
  end
  object PG_Driver: TFDPhysPgDriverLink
    Left = 568
    Top = 64
  end
  object MSSQL_Driver: TFDPhysMSSQLDriverLink
    Left = 568
    Top = 176
  end
  object Oracle_Driver: TFDPhysOracleDriverLink
    Left = 568
    Top = 232
  end
  object Mongo_Driver: TFDPhysMongoDriverLink
    Left = 568
    Top = 120
  end
end
