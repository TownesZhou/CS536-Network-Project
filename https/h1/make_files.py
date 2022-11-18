import os

if __name__ == '__main__':  
    # for root, dirs, files in os.walk('./files'):
    #     for name in files:
    #         if(name.startswith("test")):
    #             os.remove(name)

    size = ["5KB", "10KB", "100KB", "200KB", "500KB", "1MB", "10MB"]
    total_char = 0

    file_number = {"5KB":[1, 200], "10KB":[1, 100], "100KB":[1, 10], "200KB":[1, 5], "500KB":[1, 2], "1MB":[1], "10MB":[1]}

    for total_size in size:
        if total_size == "5KB":
            total_char = 1024 * 5
        elif total_size == "10KB":
            total_char = 1024 * 10
        elif total_size == "100KB":
            total_char = 1024 * 100
        elif total_size == "200KB":
            total_char = 1024 * 200
        elif total_size == "500KB":
            total_char = 1024 * 500
        elif total_size == "1MB":
            total_char = 1024 * 1024
        elif total_size == "10MB":
            total_char = 1024 * 1024 * 10
        for number in file_number[total_size]:
            for i in range(number):
                file_name = "./files/test_%s_%d_%d.txt" % (total_size, number, i)
                with open(file_name, 'w') as f:
                    f.write('0' * total_char)