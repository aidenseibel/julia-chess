import subprocess
import time 


# Path to the Stockfish executable
stockfish_path = '/opt/homebrew/bin/stockfish'

# Start Stockfish process
stockfish = subprocess.Popen(
    stockfish_path,
    universal_newlines=True,
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    bufsize=1,
    )

# Send a command to Stockfish and get the response
def send_command(command, depth):
    stockfish.stdin.write('\n' + command + '\n')
    for i in range(depth+1):
        stockfish.stdout.readline()

    if depth != -1:
        line = stockfish.stdout.readline().split()
        return line[1][:4] + " " + line[3]
    
    return " hahah "


with open("fens.csv", "r") as file:        
    stockfish.stdout.readline()

    for fen in file:
        fen = fen.strip()
        send_command(f'position fen {fen}', -1)
        evaluation = send_command(f'go depth 10', 10)  # adjust depth as needed
        print(fen+","+evaluation)


# Close the Stockfish process
stockfish.stdin.write('quit\n')
stockfish.stdin.close()
stockfish.wait()
