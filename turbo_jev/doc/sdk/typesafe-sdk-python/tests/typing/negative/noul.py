from typesafe_sdk import Noul, NoulCriteria


def invalid_nouls(criteria: NoulCriteria) -> None:
    Noul()  # E: No matching overload
    Noul(instructions=None)  # E: No matching overload
    Noul(criteria={})  # E: No matching overload
    Noul(criteria={"true": None, "false": None})  # E: No matching overload
    Noul(criteria=criteria)  # E: No matching overload
