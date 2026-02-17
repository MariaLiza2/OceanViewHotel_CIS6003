package com.oceanview.service;

import com.oceanview.model.Room;
import com.oceanview.util.DataStore;
import java.util.List;

public class RoomService {

    public List<Room> getAvailableRooms() {
        return DataStore.getInstance().getRooms();
    }
}
