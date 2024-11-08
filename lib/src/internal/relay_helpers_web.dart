
int getAckIdWithoutPacketId(int ackId) {
  return (ackId &  0xFFFFFFFF).toUnsigned(64);
}