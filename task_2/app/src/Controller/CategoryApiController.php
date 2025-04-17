<?php

namespace App\Controller;

use App\Entity\Category;
use App\Repository\CategoryRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\SerializerInterface;

#[Route('/api/category')]
class CategoryApiController extends AbstractController
{
    private $entityManager;
    private $categoryRepository;
    private $serializer;

    public function __construct(EntityManagerInterface $entityManager, CategoryRepository $categoryRepository, SerializerInterface $serializer)
    {
        $this->entityManager = $entityManager;
        $this->categoryRepository = $categoryRepository;
        $this->serializer = $serializer;
    }

    #[Route('', name: 'api_category_index', methods: ['GET'])]
    public function index(): JsonResponse
    {
        $categories = $this->categoryRepository->findAll();
        $data = $this->serializer->serialize($categories, 'json', ['groups' => 'category:read']);
        return new JsonResponse($data, 200, [], true);
    }

    #[Route('', name: 'api_category_create', methods: ['POST'])]
    public function create(Request $request): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $category = new Category();
        $category->setName($data['name'] ?? '');

        $this->entityManager->persist($category);
        $this->entityManager->flush();

        $data = $this->serializer->serialize($category, 'json', ['groups' => 'category:read']);
        return new JsonResponse($data, 201, [], true);
    }

    #[Route('/{id}', name: 'api_category_show', methods: ['GET'])]
    public function show(int $id): JsonResponse
    {
        $category = $this->categoryRepository->find($id);
        if (!$category) {
            return new JsonResponse(['error' => 'Category not found'], 404);
        }
        $data = $this->serializer->serialize($category, 'json', ['groups' => 'category:read']);
        return new JsonResponse($data, 200, [], true);
    }

    #[Route('/{id}', name: 'api_category_update', methods: ['PUT'])]
    public function update(int $id, Request $request): JsonResponse
    {
        $category = $this->categoryRepository->find($id);
        if (!$category) {
            return new JsonResponse(['error' => 'Category not found'], 404);
        }

        $data = json_decode($request->getContent(), true);
        $category->setName($data['name'] ?? $category->getName());

        $this->entityManager->flush();

        $data = $this->serializer->serialize($category, 'json', ['groups' => 'category:read']);
        return new JsonResponse($data, 200, [], true);
    }

    #[Route('/{id}', name: 'api_category_delete', methods: ['DELETE'])]
    public function delete(int $id): JsonResponse
    {
        $category = $this->categoryRepository->find($id);
        if (!$category) {
            return new JsonResponse(['error' => 'Category not found'], 404);
        }

        $this->entityManager->remove($category);
        $this->entityManager->flush();

        return new JsonResponse(null, 204);
    }
}