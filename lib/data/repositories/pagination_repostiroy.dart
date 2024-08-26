abstract class IPaginationRepository<T> {
  Future<List<T>> fetchData(int page);
}
