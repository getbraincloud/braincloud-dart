
int getAckIdWithoutPacketId(int ackId) {
  return (ackId &  0xF000FFFFFFFFFFFF).toUnsigned(64);
}