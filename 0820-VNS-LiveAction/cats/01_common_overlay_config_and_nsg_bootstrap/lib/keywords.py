from robot.api.deco import keyword


@keyword("local_lib.nsg should have active controllers")
def active_controllers(controller_info=None, controller_number=1):
    arr = [
        k
        for k, v in controller_info.items()
        if (v["state"] == "ACTIVE" and v["vsc_state"] == "FUNCTIONAL")
    ]

    if len(arr) != controller_number:
        raise Exception(
            "CATS ERROR: Number of active and functional controllers {} does not satisfy the requirement to have {} controllers".format(
                len(arr), controller_number
            )
        )
