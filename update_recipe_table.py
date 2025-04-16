import pymysql

# 資料庫連線設定（請依照你的環境修改）
DB_CONFIG = {
    "host": "127.0.0.1",
    "port": 3306,
    "user": "user",
    "password": "password",
    "database": "WiringSystemRecordsDB",
    "charset": "utf8mb4"
}

# SQL 升級語句
ALTER_SQL = """
ALTER TABLE Recipe
ADD COLUMN UpperLimit DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
ADD COLUMN Average DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
ADD COLUMN LowerLimit DECIMAL(10, 2) NOT NULL DEFAULT 0.00;
"""

UPDATE_SQL = """
UPDATE Recipe
SET 
    UpperLimit = MotorHeight + 0.10,
    Average = MotorHeight,
    LowerLimit = MotorHeight - 0.10;
"""

def upgrade_recipe_table():
    conn = None
    cursor = None
    try:
        conn = pymysql.connect(**DB_CONFIG)
        cursor = conn.cursor()

        print("嘗試修改資料表結構...")
        cursor.execute(ALTER_SQL)
        print("✅ 資料表欄位新增完成")

        print("嘗試更新欄位初始值...")
        cursor.execute(UPDATE_SQL)
        conn.commit()
        print("✅ 更新資料成功")

    except pymysql.err.InternalError as e:
        if "Duplicate column name" in str(e):
            print("⚠️ 欄位已存在，略過新增")
        else:
            print("❌ 資料表修改失敗:", e)
    except pymysql.err.OperationalError as e:
        if e.args[0] == 1045:
            print("❌ 帳號或密碼錯誤，請檢查 DB_CONFIG 設定")
        elif e.args[0] == 1060 and "Duplicate column name" in str(e):
            print("⚠️ 欄位已存在，略過新增")
        else:
            print("❌ 資料庫連線失敗:", e)
    except Exception as e:
        print("❌ 發生錯誤:", e)
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

if __name__ == "__main__":
    db_info = f"{DB_CONFIG['user']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}"
    confirm = input(f"是否要更新 [{db_info}] 的 Recipe 資料表？(y/n)：").strip().lower()
    if confirm == 'y':
        upgrade_recipe_table()
    else:
        print("已取消操作。")