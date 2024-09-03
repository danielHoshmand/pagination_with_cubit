abstract class IPaginationRepository<T, I> {
  Future<List<T>> fetchData(I key);
}
