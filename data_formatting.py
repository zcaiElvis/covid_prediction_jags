import pandas as pd
df = pd.read_csv("changes.csv", sep=" ", index_col = "date")
reg_first = "^ ([0-9]+)"
reg_last = "([0-9]+)$"
pd.DataFrame({"reported" : df["val"].str.extract(reg_first).astype(int).to_numpy().flatten(),
              "revised" : df["val"].str.extract(reg_last).astype(int).to_numpy().flatten()},
              index = df.index).to_csv("formatted_changes.csv")