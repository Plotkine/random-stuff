def enum(index, prefix, charset, suffix, output):
    if (len(output) >= 5000) or (index < 0):
        return None
    else:
        for char in charset:
            if len(output) >= 5000:
                break
            else:
                output.append(prefix + char + suffix)
                enum(index - 1, prefix[:-1], 'bcdefghijklmnopqrstuvwxyz', char + suffix, output)

output = []

for length in range(1, 1000000):
    if len(output) >= 5000:
        break
    else:
        enum(length - 1, 'a'*(length - 1), 'abcdefghijklmnopqrstuvwxyz', '', output)

with open('list.txt', 'w') as f:
    f.write('\n'.join(output))

