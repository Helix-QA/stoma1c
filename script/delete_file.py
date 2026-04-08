import os
import sys

# ===================== НАСТРОЙКИ =====================
# Можно указать пути прямо здесь, либо передать через аргументы командной строки

# Вариант 1: Жёстко прописанные пути (самый простой)
FOLDER_PATH = r"D:\AgentOneS\workspace\stoma1c_build\src"      # ←←← ИЗМЕНИТЕ НА СВОЙ ПУТЬ
FILE_NAME   = "ConfigDumpInfo.xml"               # ←←← ИЗМЕНИТЕ НА ИМЯ ФАЙЛА

# Вариант 2: Через аргументы командной строки (рекомендую)
# python delete_file.py "C:\Путь\К\Папке" "имя_файла.txt"
# ====================================================

def main():
    # Если передали аргументы командной строки — используем их
    if len(sys.argv) >= 3:
        folder_path = sys.argv[1]
        file_name   = sys.argv[2]
    else:
        folder_path = FOLDER_PATH
        file_name   = FILE_NAME

    # Проверка существования папки
    if not os.path.isdir(folder_path):
        print(f"❌ Ошибка: Папка не найдена → {folder_path}")
        sys.exit(1)

    # Полный путь к файлу
    file_path = os.path.join(folder_path, file_name)

    # Проверка существования файла
    if not os.path.exists(file_path):
        print(f"❌ Ошибка: Файл не найден → {file_path}")
        sys.exit(1)

    try:
        # Переходим в папку
        os.chdir(folder_path)
        print(f"✅ Перешли в папку: {folder_path}")

        # Удаляем файл
        os.remove(file_name)
        print(f"✅ Файл успешно удалён: {file_name}")

    except PermissionError:
        print("❌ Ошибка: Нет прав на удаление файла (возможно, файл открыт)")
    except Exception as e:
        print(f"❌ Неизвестная ошибка: {e}")

if __name__ == "__main__":
    main()